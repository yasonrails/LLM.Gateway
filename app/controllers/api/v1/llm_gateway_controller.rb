class Api::V1::LlmGatewayController < ApplicationController
  def generate
    query = params[:query]
    task = params[:task] || :generation
    sources = params[:sources] || []

    result = LLM_GATEWAY.generate_with_fetch(query, task.to_sym, sources)

    render json: { result: result }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end:LlmGatewayController < ApplicationController
  def generate
    gateway = Gateway.new
    query = params[:query]
    task = params[:task] || :generation
    sources = params[:sources] || []

    result = gateway.generate_with_fetch(query, task.to_sym, sources)

    render json: { result: result }
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end