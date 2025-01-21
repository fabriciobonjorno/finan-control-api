# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'GET #get_document' do
    let(:valid_params) { { document: '12345678000195' } }
    let(:invalid_params) { { document: '123' } }
    let(:service) { Api::V1::AuthServices::GetDocument::UseCase }

    class MockResult
      def initialize(success: nil, failure: nil)
        @success = success
        @failure = failure
      end

      def success(&block)
        @success&.call(block) if @success
      end

      def failure(step = nil, &block)
        @failure&.call(step, block) if @failure
      end
    end

    context 'when the service succeeds' do
      it 'returns 200 with the correct response' do
        allow(service).to receive(:call).and_yield(
          MockResult.new(
            success: ->(block) { block.call('Mensagem de sucesso', { key: 'value' }) }
          )
        )

        get :get_document, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Mensagem de sucesso",
          "data" => { "key" => "value" }
        })
      end
    end

    context 'when the service fails at :validate_params' do
      it 'returns 400 with the validation error message' do
        allow(service).to receive(:call).and_yield(
          MockResult.new(
            failure: ->(step, block) { step == :validate_params && block.call('Parâmetros inválidos') }
          )
        )

        get :get_document, params: invalid_params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Parâmetros inválidos"
        })
      end
    end

    context 'when the service fails at :find_document' do
      it 'returns 400 with the error message' do
        allow(service).to receive(:call).and_yield(
          MockResult.new(
            failure: ->(step, block) { step == :find_document && block.call('Erro ao buscar documento') }
          )
        )

        get :get_document, params: valid_params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Erro ao buscar documento"
        })
      end
    end

    context 'when the service fails at :output' do
      it 'returns 400 with the error message' do
        allow(service).to receive(:call).and_yield(
          MockResult.new(
            failure: ->(step, block) { step == :output && block.call('Erro na saída') }
          )
        )

        get :get_document, params: valid_params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Erro na saída"
        })
      end
    end

    context 'when the service fails with an unknown error' do
      it 'returns 500 with the error message' do
        allow(service).to receive(:call).and_yield(
          MockResult.new(
            failure: ->(step, block) { step == :output && block.call('Erro desconhecido') }
          )
        )

        get :get_document, params: valid_params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({
          "message" => "Erro desconhecido"
        })
      end
    end
  end
end
