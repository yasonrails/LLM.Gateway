module LlmGateway
  class Template
    TEMPLATES = {
      summary: "Summarize the following text: {text}",
      qa: "Answer the question based on the context: Question: {question} Context: {context}",
      generation: "Generate text on the topic: {topic}"
    }

    def self.render(template_key, variables = {})
      template = TEMPLATES[template_key.to_sym]
      return nil unless template

      variables.each do |key, value|
        template = template.gsub("{#{key}}", value.to_s)
      end
      template
    end
  end
end