class AiTextProcessor
  def initialize
    @gateway = LLM_GATEWAY
  end

  def summarize(text)
    @gateway.generate_with_fetch(text, :summary)
  end

  def answer_question(question, context_urls = [])
    @gateway.generate_with_fetch(question, :qa, context_urls, question: question)
  end

  def classify(text)
    @gateway.generate_with_fetch(text, :classification)
  end
end