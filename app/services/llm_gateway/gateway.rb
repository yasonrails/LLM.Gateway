module LlmGateway
  class Gateway
    def initialize
      @adapters = load_adapters
      @cache = LlmGateway::Cache.new
      @fetcher = Fetchers::ExternalFetcher.new
    end

    def generate_with_fetch(query, task = :generation, sources = [], options = {})
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

    def load_adapters
      [
        LlmGateway::Adapters::OllamaAdapter.new,
        LlmGateway::Adapters::LocalaiAdapter.new,
        LlmGateway::Adapters::LlamacppAdapter.new
      ]
    end
  end
end