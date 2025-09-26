# LLM Gateway Prototype

This is a prototype MVP for an LLM Gateway that provides a unified interface for multiple local LLM services (Ollama, LocalAI, llama.cpp), with external data fetching, caching, and prompt templating.

## Features

- **Unified LLM Interface**: Supports multiple adapters for different LLM engines.
- **External Data Fetching**: Fetch and integrate public web data into prompts.
- **Caching**: Simple caching to avoid repeated computations.
- **Prompt Templates**: Predefined templates for common tasks.
- **Modular Design**: Easy to add new adapters or fetchers.

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Ensure LLM services are running:
   - Ollama: `ollama serve` (default port 11434)
   - LocalAI: Run LocalAI server (default port 8080)
   - llama.cpp: Run llama.cpp server (default port 8080)

3. Start the Rails server:
   ```bash
   rails server
   ```

## API Usage

### Generate Response

Endpoint: `POST /api/v1/llm/generate`

Parameters:
- `query`: The main query or topic
- `task`: Template to use (:summary, :qa, :generation) (default: :generation)
- `sources`: Array of URLs to fetch data from (optional)

Example using curl:

```bash
curl -X POST http://localhost:3000/api/v1/llm/generate \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What is the latest news on AI?",
    "task": "summary",
    "sources": ["https://example.com/news1", "https://example.com/news2"]
  }'
```

Response:
```json
{
  "result": "Summarized content based on fetched data and LLM generation..."
}
```

## Structure

- `app/services/llm_gateway.rb`: Main gateway service
- `app/services/adapters/`: LLM adapters (Base, Ollama, LocalAI, llama.cpp)
- `app/services/fetchers/external_fetcher.rb`: Web data fetcher
- `app/services/cache/simple_cache.rb`: Caching service
- `app/services/templates/prompt_templates.rb`: Prompt templates
- `app/controllers/api/v1/llm_gateway_controller.rb`: API controller

## Adding New Adapters

Create a new class in `app/services/adapters/` inheriting from `Adapters::BaseAdapter`, implementing `generate` and `available?` methods.

## Adding New Fetchers

Create a new class in `app/services/fetchers/` with a `fetch_data` method.

This is a prototype and not production-ready. Add error handling, authentication, rate limiting, etc., for production use.
