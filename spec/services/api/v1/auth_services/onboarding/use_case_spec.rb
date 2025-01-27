# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::AuthServices::Onboarding::UseCase, type: :service do
  subject { described_class.new }

  let(:valid_params) do
    {
      document: '12345678000195',
      legal_name: 'Empresa Teste',
      trade_name: 'Teste LTDA',
      first_name: 'João',
      last_name: 'Silva',
      email: 'joao.silva@example.com',
      password: 'Senha@123',
      password_confirmation: 'Senha@123',
      plan_id: plan.id
    }
  end

  let(:plan) { create(:plan, plan_type: :monthly) }

  describe 'steps' do
    context 'with valid params' do
      it 'completes the onboarding successfully and sends confirmation email' do
        role_mock = instance_double(Role)
        allow(role_mock).to receive(:id).and_return(1)
        allow(role_mock).to receive(:invalid?).and_return(false)
        allow(role_mock).to receive(:errors).and_return(double(full_messages: []))

        company_mock = instance_double(Company)
        allow(company_mock).to receive(:roles).and_return(double(build: role_mock))
        allow(company_mock).to receive(:id).and_return(1)
        allow(company_mock).to receive(:legal_name).and_return('Empresa Teste')
        allow(company_mock).to receive(:trade_name).and_return('Teste LTDA')
        allow(company_mock).to receive(:document).and_return('12345678000195')
        allow(company_mock).to receive(:invalid?).and_return(false)
        allow(company_mock).to receive(:errors).and_return(double(full_messages: []))

        user_mock = instance_double(User)
        allow(user_mock).to receive(:id).and_return(1)
        allow(user_mock).to receive(:invalid?).and_return(false)
        allow(user_mock).to receive(:errors).and_return(double(full_messages: []))
        allow(user_mock).to receive(:generate_confirmation_token)

        customer_mock = instance_double(Customer)
        companies_association_mock = double('CompanyAssociation')
        allow(companies_association_mock).to receive(:build).and_return(company_mock)
        allow(companies_association_mock).to receive(:first).and_return(company_mock)
        allow(customer_mock).to receive(:companies).and_return(companies_association_mock)
        allow(customer_mock).to receive(:users).and_return(double(build: user_mock))
        allow(customer_mock).to receive(:invalid?).and_return(false)
        allow(customer_mock).to receive(:errors).and_return(double(full_messages: []))
        allow(customer_mock).to receive(:save).and_return(true)
        allow(customer_mock).to receive(:plan).and_return(plan)
        allow(customer_mock).to receive(:plan_start_date).and_return('2025-01-01')
        allow(customer_mock).to receive(:plan_end_date).and_return('2025-12-31')

        allow(Customer).to receive(:new).and_return(customer_mock)

        allow(Util).to receive(:normalize_customer_name).and_return('Empresa Teste')

        mailer_mock = double('Mailer')
        allow(mailer_mock).to receive(:deliver)
        allow(ApplicationMailer).to receive(:send_confirmation_token).and_return(mailer_mock)

        result = subject.call(ActionController::Parameters.new(valid_params))
        expect(result).to be_success

        expect(user_mock).to have_received(:generate_confirmation_token)

        expect(ApplicationMailer).to have_received(:send_confirmation_token).with(user_mock)
        expect(mailer_mock).to have_received(:deliver)
      end
    end
  end
end
