require 'faraday'

module LlmGateway
  module Adapters
    class LocalaiAdapter < Base
      def initialize(config = {})
        super
    @base_url = config[:base_url] || 'http://localhost:8080'
    @model = config[:model] || 'gpt-3.5-turbo'
  end

  def generate(prompt, options = {})
    response = Faraday.post("#{@base_url}/v1/chat/completions") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        model: @model,
        messages: [{ role: 'user', content: prompt }],
        stream: false
      }.merge(options).to_json
    end

    if response.success?
      JSON.parse(response.body)['choices'].first['message']['content']
    else
      raise "LocalAI API error: #{response.status} - #{response.body}"
    end
  rescue Faraday::Error => e
    raise "Connection error: #{e.message}"
  end

  def available?
    Faraday.get("#{@base_url}/v1/models").success?
  rescue
    false
  end
    end
  end
end