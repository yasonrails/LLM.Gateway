module LlmGateway
  class TemplateManager
    def initialize
      @templates = {}
      load_templates
    end

    def render(name, variables = {})
      template = @templates[name]
      return nil unless template

      variables.each do |key, value|
        template = template.gsub("{#{key}}", value.to_s)
      end
      template
    end

    private

    def load_templates
      Dir.glob(Rails.root.join('app', 'services', 'llm_gateway', 'templates', '*.yml')).each do |file|
        name = File.basename(file, '.yml')
        @templates[name] = YAML.load_file(file)['template']
      end
    end
  end
end