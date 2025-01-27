# frozen_string_literal: true

require "rails_helper"
require 'ostruct'

RSpec.describe Api::V1::AuthServices::Onboarding::Presenter, type: :service do
  subject { described_class.new }

  let(:company) do
    OpenStruct.new(
      legal_name: 'Empresa Teste',
      trade_name: 'Teste LTDA',
      document: '12345678000195'
    )
  end

  let(:plan) { create(:plan, name: 'Plano Premium', plan_type: :monthly) }

  let(:valid_result) do
    OpenStruct.new(
      companies: [ company ],
      plan: plan,
      plan_start_date: '2025-01-01',
      plan_end_date: '2025-12-31'
    )
  end

  describe '#call' do
    it 'formats onboarding data correctly' do
      result = subject.call(valid_result)

      expect(result).to eq({
        legal_name: 'Empresa Teste',
        trade_name: 'Teste LTDA',
        document: '12.345.678/0001-95',
        plan: 'Plano Premium',
        plan_start_date: '2025-01-01',
        plan_end_date: '2025-12-31'
      })
    end
  end
end
