module LlmGateway
  class Gateway
    def initialize
      @adapters = load_adapters
      @cache = LlmGateway::Cache.new
      @fetcher = Fetchers::ExternalFetcher.new
    rescue => e
      Rails.logger.error "Erreur d'initialisation: #{e.message}"
      @mock_mode = true
    end

    def generate_with_fetch(query, task = :generation, sources = [], options = {})
      # Mode simulation si les services externes ne sont pas disponibles
      if @mock_mode
        return mock_response(query, task)
      end
      
      # Fetch data if sources provided
      fetched_data = @fetcher.fetch_data(query, sources) if sources.any?

      # Build prompt using template
      context = fetched_data.map { |d| d[:content] }.join("\n") if fetched_data
      prompt = LlmGateway::Template.render(task, text: context || query, question: query, topic: query)

      # Cache key
      cache_key = "llm:#{Digest::MD5.hexdigest(prompt)}"

      # Check cache
      cached = @cache.read(cache_key)
      return cached if cached

      # Generate with fallback
      result = nil
      @adapters.each do |adapter|
        next unless adapter.available?
        begin
          result = adapter.generate(prompt, options)
          break
        rescue => e
          Rails.logger.warn "Adapter #{adapter.class} failed: #{e.message}"
          next
        end
      end

      raise "All adapters failed" unless result

      # Cache result
      @cache.write(cache_key, result, expires_in: 1.hour)

      result
    end

    private

    def mock_response(query, task)
      case task
      when :summary
        "Voici un résumé simulé pour la requête : #{query}"
      when :qa
        "Réponse simulée à la question : #{query}"
      when :classification
        "Classification simulée du texte : #{query}"
      else
        "Ceci est une réponse simulée du LLM Gateway pour la requête : #{query}.\n\nLe système est en mode simulation car les services LLM (Ollama, LocalAI, llama.cpp) ne sont pas disponibles."
      end
    end

    def load_adapters
      [
        LlmGateway::Adapters::OllamaAdapter.new,
        LlmGateway::Adapters::LocalaiAdapter.new,
        LlmGateway::Adapters::LlamacppAdapter.new
      ]
    end
  end
end