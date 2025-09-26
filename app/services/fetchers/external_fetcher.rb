module Fetchers
  class ExternalFetcher
    def initialize(config = {})
      @config = config
    end

    def fetch_data(query, sources = [])
      # For simplicity, assume sources are URLs
      results = []
      sources.each do |url|
        begin
          response = Faraday.get(url)
          if response.success?
            content = extract_text(response.body)
            results << { url: url, content: content }
          end
        rescue => e
          Rails.logger.error "Error fetching #{url}: #{e.message}"
        end
      end
      results
    end

    private

    def extract_text(html)
      doc = Nokogiri::HTML(html)
      doc.text.strip
    end
  end
end