# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthServices::GetDocument::UseCase, type: :service do
  subject { described_class.new }

  let(:valid_params) { { document: Faker::Company.brazilian_company_number } }
  let(:invalid_params) { { document: '123' } }

  describe 'call' do
    context 'with valid params' do
      before do
        allow(Util).to receive(:company_data).and_return(company_data_response)
      end

      let(:company_data_response) do
        {
          "razao_social" => "Empresa Teste",
          "estabelecimento" => {
            "nome_fantasia" => "Teste LTDA",
            "cnpj" => "12345678000195",
            "situacao_cadastral" => "Ativa"
          }
        }
      end

      it 'returns company data if document is valid and active' do
        params = ActionController::Parameters.new(valid_params)
        result = subject.call(params)

        expect(result).to be_success
        expect(result.success).to include('Dados da empresa!')
      end

      it 'returns failure if company is inactive' do
        allow(Util).to receive(:company_data).and_return(company_data_response.merge(
          "estabelecimento" => { "situacao_cadastral" => "Inativa" }
        ))

        params = ActionController::Parameters.new(valid_params)
        result = subject.call(params)

        expect(result).to be_failure
        expect(result.failure).to eq("Empresa Inativa: não é possível prosseguir com o cadastro!")
      end

      it 'returns failure if company data is not found' do
        allow(Util).to receive(:company_data).and_return(nil)

        params = ActionController::Parameters.new(valid_params)
        result = subject.call(params)

        expect(result).to be_failure
        expect(result.failure).to eq("Não foi possível buscar dados da empresa!")
      end

      it 'returns failure if status is nil and company not found' do
        allow(Util).to receive(:company_data).and_return({
          "status" => 404,
          "estabelecimento" => { "situacao_cadastral" => nil }
        })

        params = ActionController::Parameters.new(valid_params)
        result = subject.call(params)

        expect(result).to be_failure
        expect(result.failure).to eq("Empresa não encontrada!")
      end
    end

    context 'with invalid params' do
      it 'returns validation errors' do
        params = ActionController::Parameters.new(invalid_params)
        result = subject.call(params)

        expect(result).to be_failure
        expect(result.failure).to include("O documento fornecido é inválido ou está incompleto!")
      end
    end
  end
end
