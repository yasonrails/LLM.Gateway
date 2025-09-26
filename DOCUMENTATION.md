# Documentation du LLM Gateway

## Vue d'ensemble

Le LLM Gateway est une passerelle centralisée pour gérer plusieurs modèles de langage locaux (LLM) avec des capacités avancées :

- **Multi-moteurs** : Supporte Ollama, LocalAI, llama.cpp
- **Fallback automatique** : Bascule vers d'autres modèles si le principal échoue
- **Mise en cache** : Évite les requêtes répétées
- **Récupération externe** : Récupère des données web pour enrichir les prompts
- **Templates** : Modèles de prompts par type de tâche

## Architecture

```
LLM.Gateway/
├── app/services/llm_gateway/
│   ├── adapters/            # Adaptateurs pour chaque moteur LLM
│   ├── cache.rb            # Système de cache
│   ├── gateway.rb          # Point d'entrée principal
│   ├── metrics.rb          # Collection de métriques
│   ├── model_registry.rb   # Registre des modèles
│   ├── template.rb         # Système de templates
│   └── templates/          # Templates YAML
└── config/
    └── llm_models/         # Configuration des modèles
```

## Utilisation API

### Génération de texte

```bash
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Qu'\''est-ce que l'\''intelligence artificielle?",
    "task": "generation"
  }'
```

### Résumé de texte

```bash
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Résumer ce texte",
    "task": "summary",
    "sources": ["https://fr.wikipedia.org/wiki/Intelligence_artificielle"]
  }'
```

### Question-réponse avec contexte

```bash
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Quels sont les types d'\''IA?",
    "task": "qa",
    "sources": ["https://fr.wikipedia.org/wiki/Intelligence_artificielle"]
  }'
```

## Utilisation dans le code

```ruby
# Utilisation directe
result = LLM_GATEWAY.generate_with_fetch("Qu'est-ce que l'IA?", :generation)

# Avec le AiTextProcessor
processor = AiTextProcessor.new
summary = processor.summarize("Long texte ici...")
answer = processor.answer_question("Comment fonctionne l'IA?", ["https://example.com/ia"])
classification = processor.classify("Ce produit est excellent!")
```

## Configuration

Chaque modèle est configuré via un fichier YAML dans `config/llm_models/`:

```yaml
adapter: ollama
model: llama3
base_url: http://localhost:11434
context_length: 4096
performance: high
```

## Déploiement

Le projet inclut des configurations Docker pour un déploiement facile :

```bash
# Construction de l'image
docker build -t llm-gateway .

# Lancement des conteneurs
docker-compose up -d
```