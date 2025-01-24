# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCompanyRole, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
    it { should belong_to(:role) }
  end

  describe "validations" do
    subject(:user) { create(:user) }
    subject(:company) { create(:company) }
    subject(:role) { create(:role) }

    context "presence validations" do
      it "is valid with a user, company, and role" do
        user_company_role = build(:user_company_role, user: user, company: company, role: role)
        expect(user_company_role).to be_valid
      end

      it "is invalid without a user" do
        user_company_role = build(:user_company_role, user: nil, company: company, role: role)
        expect(user_company_role).not_to be_valid
        expect(user_company_role.errors[:user]).to include("não pode ficar em branco")
      end

      it "is invalid without a company" do
        user_company_role = build(:user_company_role, user: user, company: nil, role: role)
        expect(user_company_role).not_to be_valid
        expect(user_company_role.errors[:company]).to include("não pode ficar em branco")
      end

      it "is invalid without a role" do
        user_company_role = build(:user_company_role, user: user, company: company, role: nil)
        expect(user_company_role).not_to be_valid
        expect(user_company_role.errors[:role]).to include("não pode ficar em branco")
      end
    end

    context "uniqueness validation" do
      it "is invalid if the same user has the same role in the same company" do
        create(:user_company_role, user: user, company: company, role: role)
        duplicate_user_company_role = build(:user_company_role, user: user, company: company, role: role)

        expect(duplicate_user_company_role).not_to be_valid
        expect(duplicate_user_company_role.errors[:user_id]).to include("já possui este perfil nessa empresa")
      end
    end
  end
end
