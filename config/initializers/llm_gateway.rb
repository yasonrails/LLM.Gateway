require_relative '../../app/services/llm_gateway/gateway'
require_relative '../../app/services/llm_gateway/cache'
require_relative '../../app/services/llm_gateway/template'
require_relative '../../app/services/llm_gateway/adapters/base'
require_relative '../../app/services/llm_gateway/adapters/ollama_adapter'
require_relative '../../app/services/llm_gateway/adapters/localai_adapter'
require_relative '../../app/services/llm_gateway/adapters/llamacpp_adapter'
require_relative '../../app/services/fetchers/external_fetcher'

LLM_GATEWAY = LlmGateway::Gateway.new