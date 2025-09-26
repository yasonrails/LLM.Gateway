# Configuration Docker pour LLM.Gateway

Ce fichier Dockerfile crée une image Docker pour l'application LLM.Gateway.

```Dockerfile
FROM ruby:3.2.2

# Installation des dépendances
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev nodejs npm

# Définir le répertoire de travail
WORKDIR /app

# Installer les gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copier l'application
COPY . .

# Exposer le port
EXPOSE 3000

# Commande de démarrage
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## Docker Compose pour environnement de développement complet

Le fichier docker-compose.yml ci-dessous configure une stack complète avec:

1. L'application Rails (LLM.Gateway)
2. Ollama pour les modèles LLM
3. LocalAI comme alternative

```yaml
version: '3'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    depends_on:
      - ollama
      - localai
    environment:
      RAILS_ENV: development

  ollama:
    image: ollama/ollama:latest
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"

  localai:
    image: localai/localai:latest
    volumes:
      - localai_data:/app/data
    ports:
      - "8080:8080"
    environment:
      - MODELS_PATH=/app/data

volumes:
  ollama_data:
  localai_data:
```

## Utilisation

1. Construire et démarrer les services:
   ```bash
   docker compose up -d
   ```

2. Arrêter les services:
   ```bash
   docker compose down
   ```

3. Accéder à l'application Rails:
   http://localhost:3000

4. Accéder à Ollama directement:
   http://localhost:11434

5. Accéder à LocalAI:
   http://localhost:8080