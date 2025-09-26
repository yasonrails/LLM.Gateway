module LlmGateway
  class Cache
    def initialize(store = Rails.cache)
      @store = store
    end

    def fetch(key, options = {})
      @store.fetch(key, options) do
        yield
      end
    end

    def write(key, value, options = {})
      @store.write(key, value, options)
    end

    def read(key)
      @store.read(key)
    end

    def exist?(key)
      @store.exist?(key)
    end

    def delete(key)
      @store.delete(key)
    end
  end
end