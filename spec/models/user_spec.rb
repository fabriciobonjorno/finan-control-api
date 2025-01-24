# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "associations" do
    it { should belong_to(:customer) }
    it { should have_many(:user_company_roles).dependent(:restrict_with_error) }
    it { should have_many(:companies).through(:user_company_roles) }
    it { should have_many(:roles).through(:user_company_roles) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    context 'with account_validation enabled' do
      before { subject.account_validation = true }

      it { should validate_presence_of(:birth_date) }
      it { should validate_presence_of(:document) }
    end

    it 'validates email format' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('é inválido')
    end

    it 'validates password format' do
      user = build(:user, password: 'weak')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('mínimo 8 caracteres, incluindo 1 letra maiúscula, 1 número, 1 caractere especial')
    end
  end

  describe 'callbacks' do
    it 'capitalizes first and last name before saving' do
      user = create(:user, first_name: 'joHN', last_name: 'doE')
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
    end
  end

  describe 'token management' do
    let(:user) { create(:user) }

    it 'manages confirmation token correctly' do
      user.generate_confirmation_token
      expect(user.confirmation_token).not_to be_nil
      expect(user.confirmation_token_is_valid?).to be true

      user.reset_confirmation_token
      expect(user.confirmation_token).to be_nil
    end

    it 'manages reset password token correctly' do
      user.generate_reset_password_token
      expect(user.reset_password_token).not_to be_nil
      expect(user.reset_token_is_valid?).to be true

      user.reset_reset_password_token
      expect(user.reset_password_token).to be_nil
    end
  end

  describe 'account management' do
    let(:user) { create(:user) }

    context 'failed attempts' do
      it 'locks account after 3 login failed attempts' do
        3.times { user.update_login_failed_attempts }
        expect(user.locked).to be true
        expect(user.locked_at).not_to be_nil
      end

      it 'resets login failed attempts' do
        user.update_login_failed_attempts
        user.reset_login_failed_attempts
        expect(user.login_failed_attempts).to eq(0)
        expect(user.locked).to be false
      end

      it 'locks account after 3 token failed attempts' do
        3.times { user.update_token_failed_attempts }
        expect(user.locked).to be true
        expect(user.locked_at).not_to be_nil
      end

      it 'resets token failed attempts' do
        user.update_token_failed_attempts
        user.reset_token_failed_attempts
        expect(user.token_failed_attempts).to eq(0)
        expect(user.locked).to be false
      end

      it 'locks account after 3 transaction failed attempts' do
        3.times { user.update_transaction_failed_attempts }
        expect(user.locked).to be true
        expect(user.locked_at).not_to be_nil
      end

      it 'resets transaction failed attempts' do
        user.update_transaction_failed_attempts
        user.reset_transaction_failed_attempts
        expect(user.transaction_failed_attempts).to eq(0)
        expect(user.locked).to be false
      end
    end

    it 'confirms the account' do
      expect(user.confirmed).to be false
      user.confirm_account
      expect(user.confirmed).to be true
    end
  end
end
