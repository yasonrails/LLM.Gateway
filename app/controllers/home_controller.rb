class HomeController < ApplicationController
  def index
    # Render the index view
  end

  def test_mock
    query = "Qu'est-ce que l'intelligence artificielle?"
    task = :generation

    # Mode simulation directe pour le test
    result = {
      query: query,
      task: task,
      result: "Ceci est une réponse simulée du LLM Gateway. L'intelligence artificielle est un domaine de l'informatique qui vise à créer des machines capables d'imiter l'intelligence humaine."
    }

    render json: result
  end
end