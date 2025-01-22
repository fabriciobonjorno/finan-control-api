# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :model do
  subject(:company) { build(:company) }

  describe "associations" do
    it { should belong_to(:customer) }
    it { should have_many(:roles).dependent(:restrict_with_error) }
  end


  describe "validations" do
    it { should validate_presence_of(:legal_name) }
    it { should validate_presence_of(:trade_name) }
    it { should validate_presence_of(:document) }
    it { should validate_uniqueness_of(:document).case_insensitive }

    context "when account_validation is true" do
      before { company.account_validation = true }

      it { should validate_presence_of(:founding_date) }
      it { should validate_presence_of(:business_type) }
      it { should validate_presence_of(:main_activity) }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }

      it "accepts valid business_type values" do
        valid_business_types = %i[EI MEI EPP EIRELI LTDA SA_OPEN SA_CLOSED]
        valid_business_types.each do |type|
          company.business_type = type
          expect(company).to be_valid
        end
      end

      it "raises error for invalid business_type" do
        expect { company.business_type = :invalid_type }.to raise_error(ArgumentError, "'invalid_type' is not a valid business_type")
      end
    end

    it "validates document presence and invalid" do
      company.document = "12345678901234"
      expect(company).not_to be_valid
      expect(company.errors[:base]).to include("invalid document")
    end

    context "when account_validation is false" do
      before { company.account_validation = false }

      it "does not validate presence of founding_date" do
        company.founding_date = nil
        expect(company).to be_valid
      end

      it "does not validate presence of business_type" do
        company.business_type = nil
        expect(company).to be_valid
      end

      it "does not validate presence of main_activity" do
        company.main_activity = nil
        expect(company).to be_valid
      end

      it "does not validate presence of email" do
        company.email = nil
        expect(company).to be_valid
      end
    end
  end

  describe "soft delete" do
    it "sets deleted_at when soft_delete is called" do
      company.save
      company.soft_delete
      expect(company.deleted_at).not_to be_nil
    end

    it "reactivates a soft-deleted account" do
      company.save
      company.soft_delete
      company.activate_deleted_at
      expect(company.deleted_at).to be_nil
    end
  end

  describe "token methods" do
    it "generates and retrieves SMS token correctly" do
      company.sms_token = "sms123!"
      expect(company.sms_token).to eq "sms123!"
    end

    it "generates and retrieves email token correctly" do
      company.email_token = "email123!"
      expect(company.email_token).to eq "email123!"
    end
  end

  describe "callbacks" do
    it "capitalizes the legal and trade names before saving" do
      company.legal_name = "my company"
      company.trade_name = "my company ltd"
      company.save
      expect(company.legal_name).to eq("My Company")
      expect(company.trade_name).to eq("My Company Ltd")
    end

    it "normalizes the email field by stripping and downcasing" do
      company.email = "  test@ExaMPlE.com "
      company.save
      expect(company.email).to eq("test@example.com")
    end

    it "normalizes legal_name and trade_name by stripping digits" do
      company.legal_name = "My Comp123any"
      company.trade_name = "My Trade Name 123"
      company.save
      expect(company.legal_name).to eq("My Company")
      expect(company.trade_name).to eq("My Trade Name")
    end
  end
end
