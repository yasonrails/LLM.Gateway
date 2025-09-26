module LlmGateway
  module Adapters
    class Base
      def initialize(config = {})
        @config = config
      end

      def generate(prompt, options = {})
        raise NotImplementedError, "Subclasses must implement the generate method"
      end

      def available?
        raise NotImplementedError, "Subclasses must implement the available? method"
      end
    end
  end
end