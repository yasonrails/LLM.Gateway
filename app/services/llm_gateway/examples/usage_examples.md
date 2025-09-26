# Exemple d'utilisation du LLM Gateway

## Résumé d'un article

```ruby
processor = AiTextProcessor.new
summary = processor.summarize("Voici un long texte que je souhaite résumer...")
puts summary
```

## Question avec contexte externe

```ruby
processor = AiTextProcessor.new
answer = processor.answer_question(
  "Quels sont les avantages des transformers?",
  ["https://fr.wikipedia.org/wiki/Transformer_(mod%C3%A8le)"]
)
puts answer
```

## Classification de texte

```ruby
processor = AiTextProcessor.new
classification = processor.classify("Ce film était vraiment captivant et les effets spéciaux étaient incroyables!")
puts classification # Devrait retourner une catégorie comme "Critique positive de film"
```

## Utilisation directe de l'API Gateway

```ruby
# Via l'API REST
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Explique-moi les réseaux de neurones",
    "task": "generation"
  }'

# Avec sources externes
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Résume cet article",
    "task": "summary",
    "sources": ["https://example.com/article-sur-ia"]
  }'
```

## Récupération de données avec ExternalFetcher

```ruby
fetcher = Fetchers::ExternalFetcher.new
data = fetcher.fetch_data("intelligence artificielle", ["https://fr.wikipedia.org/wiki/Intelligence_artificielle"])
puts data.first[:content].slice(0, 200) # Affiche les 200 premiers caractères du contenu récupéré
```