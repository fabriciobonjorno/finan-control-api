# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthServices::GetDocument::Presenter, type: :service do
  subject { described_class.new }

  let(:valid_data) do
    {
      "razao_social" => "Empresa Teste",
      "estabelecimento" => {
        "nome_fantasia" => "Teste LTDA",
        "cnpj" => "12345678000195"
      }
    }
  end

  describe '#call' do
    it 'returns formatted company data' do
      result = subject.call(valid_data)
      expect(result).to eq({
        legal_name: "Empresa Teste",
        trade_name: "Teste LTDA",
        document: "12.345.678/0001-95"
      })
    end
  end
end
