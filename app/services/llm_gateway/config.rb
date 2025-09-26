module LlmGateway
  class Config
    attr_accessor :adapters, :cache_store, :default_timeout

    def initialize
      @adapters = []
      @cache_store = Rails.cache
      @default_timeout = 30
    end
  end
end