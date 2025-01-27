# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthServices::Onboarding::Contract, type: :contract do
  subject { described_class.new }

  describe 'validation' do
    context 'when all parameters are valid' do
      it 'passes validation' do
        params = {
          document: '12345678000195',
          legal_name: 'Empresa Teste',
          trade_name: 'Teste LTDA',
          first_name: 'João',
          last_name: 'Silva',
          email: 'joao.silva@example.com',
          password: 'Senha@123',
          password_confirmation: 'Senha@123',
          plan_id: '1'
        }
        result = subject.call(params)
        expect(result.success?).to be_truthy
      end
    end

    context 'when document is invalid' do
      it 'fails validation' do
        params = { document: '123' }
        result = subject.call(params)
        expect(result.success?).to be_falsey
        expect(result.errors[:document]).to include(I18n.t("api.auth.document"))
      end
    end

    context 'when passwords do not match' do
      it 'fails validation' do
        params = {
          password: 'Senha@123',
          password_confirmation: 'Senha@124'
        }
        result = subject.call(params)
        expect(result.success?).to be_falsey
        expect(result.errors[:password_confirmation]).to include(I18n.t("api.auth.password_confirmation"))
      end
    end
  end
end
