# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthServices::GetDocument::Contract, type: :contract do
  subject { described_class.new }

  describe 'validation' do
    context 'when document is valid' do
      it 'passes validation' do
        result = subject.call({ document: '12345678000195' }) # Substitua por um CNPJ válido
        expect(result.success?).to be_truthy
      end
    end

    context 'when document is invalid' do
      it 'fails validation' do
        result = subject.call({ document: '123' })
        expect(result.success?).to be_falsey
        expect(result.errors.to_h[:document]).to include("O documento fornecido é inválido ou está incompleto!")
      end
    end
  end
end
