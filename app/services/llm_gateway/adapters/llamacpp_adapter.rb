require 'faraday'

module LlmGateway
  module Adapters
    class LlamacppAdapter < Base
      def initialize(config = {})
        super
    @base_url = config[:base_url] || 'http://localhost:8080'
    @model = config[:model] || 'llama'
  end

  def generate(prompt, options = {})
    # Assuming llama.cpp server has /completion endpoint similar to some implementations
    response = Faraday.post("#{@base_url}/completion") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        prompt: prompt,
        n_predict: options[:max_tokens] || 100,
        stream: false
      }.to_json
    end

    if response.success?
      JSON.parse(response.body)['content']
    else
      raise "llama.cpp API error: #{response.status} - #{response.body}"
    end
  rescue Faraday::Error => e
    raise "Connection error: #{e.message}"
  end

  def available?
    Faraday.get("#{@base_url}/health").success?
  rescue
    false
  end
    end
  end
end