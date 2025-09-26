require 'faraday'

module LlmGateway
  module Adapters
    class OllamaAdapter < Base
      def initialize(config = {})
        super
    @base_url = config[:base_url] || 'http://localhost:11434'
    @model = config[:model] || 'llama2'
  end

  def generate(prompt, options = {})
    response = Faraday.post("#{@base_url}/api/generate") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        model: @model,
        prompt: prompt,
        stream: false
      }.merge(options).to_json
    end

    if response.success?
      JSON.parse(response.body)['response']
    else
      raise "Ollama API error: #{response.status} - #{response.body}"
    end
  rescue Faraday::Error => e
    raise "Connection error: #{e.message}"
  end

  def available?
    Faraday.get("#{@base_url}/api/tags").success?
  rescue
    false
  end
    end
  end
end