module LlmGateway
  class Template
    TEMPLATES = {
      summary: "Résume le texte suivant de manière concise et claire: {text}",
      qa: "Réponds à la question suivante en utilisant uniquement les informations du contexte fourni. Question: {question} Contexte: {context}",
      generation: "Génère un texte informatif et détaillé sur le sujet suivant: {topic}",
      classification: "Classe le texte suivant dans une catégorie appropriée: {text}"
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