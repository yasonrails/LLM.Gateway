module LlmGateway
  class ModelRegistry
    def initialize
      @models = {}
      load_models
    end

    def get_model(name)
      @models[name]
    end

    def register_model(name, config)
      @models[name] = config
    end

    private

    def load_models
      # Load from config/llm_models/*.yml
      Dir.glob(Rails.root.join('config', 'llm_models', '*.yml')).each do |file|
        name = File.basename(file, '.yml')
        config = YAML.load_file(file)
        register_model(name, config)
      end
    end
  end
end