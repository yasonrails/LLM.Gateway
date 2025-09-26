# LLM Gateway - Passerelle pour modèles de langage locaux

Une passerelle robuste et professionnelle pour gérer plusieurs moteurs LLM locaux (Ollama, LocalAI, llama.cpp) avec cache, fallback et récupération de données externes.

## Fonctionnalités

- **Interface unifiée** pour plusieurs moteurs LLM
- **Système de fallback** automatique si un moteur tombe en panne
- **Mise en cache** pour éviter les requêtes répétées
- **Récupération externe** de données du web
- **Templates de prompts** pour différentes tâches
- **Architecture modulaire** et extensible

## Installation

1. Installer les dépendances:
   ```bash
   bundle install
   ```

2. S'assurer que les services LLM sont en cours d'exécution:
   - Ollama: `ollama serve` (port par défaut 11434)
   - LocalAI: Serveur LocalAI (port par défaut 8080)
   - llama.cpp: Serveur llama.cpp (port par défaut 8080)

3. Démarrer le serveur Rails:
   ```bash
   rails server
   ```

## Utilisation de l'API

### Génération de texte

Endpoint: `POST /api/v1/llm/generate`

Paramètres:
- `query`: La requête principale
- `task`: Template à utiliser (:summary, :qa, :generation, :classification) (défaut: :generation)
- `sources`: Tableau d'URLs pour récupérer des données (optionnel)

Exemple avec curl:

```bash
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Qu'\''est-ce que l'\''intelligence artificielle?",
    "task": "generation"
  }'
```

Réponse:
```json
{
  "result": "L'intelligence artificielle (IA) désigne les systèmes conçus pour imiter l'intelligence humaine..."
}
```

## Architecture

- **Gateway**: Point d'entrée principal coordonnant les composants
- **Adapters**: Interface pour chaque moteur LLM (Ollama, LocalAI, llama.cpp)
- **Cache**: Évite les requêtes répétées
- **Fetcher**: Récupère des données du web
- **Templates**: Modèles de prompts pour différentes tâches
- **Model Registry**: Configuration et gestion des modèles

## Voir aussi

Consultez [DOCUMENTATION.md](DOCUMENTATION.md) pour plus de détails techniques et d'exemples.

## Docker

Un fichier Docker et docker-compose sont fournis pour faciliter le déploiement:

```bash
docker-compose up -d
```

## Contribution

Ce projet est un prototype modulaire conçu pour être facilement étendu. Vous pouvez ajouter:
- De nouveaux adaptateurs LLM
- Des fetchers pour d'autres sources de données
- Des templates de prompts supplémentaires
