# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject(:customer) { build(:customer) }

  describe "associations" do
    it { should belong_to(:plan) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:terms_accepted).with_message("Para continuar, você precisa concordar com os termos") }

    it "validates uniqueness of name case insensitively" do
      create(:customer, name: "Unique Name")
      expect(build(:customer, name: "unique name")).to be_invalid
    end
  end

  describe "soft delete" do
    it "sets deleted_at when soft_delete is called" do
      customer.save
      customer.soft_delete
      expect(customer.deleted_at).not_to be_nil
    end

    it "reactivates a soft-deleted account" do
      customer.save
      customer.soft_delete
      customer.activate_deleted_at
      expect(customer.deleted_at).to be_nil
    end
  end

  describe "callbacks" do
    context "before_save" do
      it "sets terms_accepted_at when a new record is created" do
        plan = create(:plan)
        customer = Customer.new(name: "Test Customer", terms_accepted: true, plan: plan)
        expect(customer.terms_accepted_at).to be_nil
        customer.save
        expect(customer.terms_accepted_at).to be_within(1.second).of(Time.current)
      end

      it "does not change terms_accepted_at for existing records" do
        existing_customer = create(:customer)
        original_terms_accepted_at = existing_customer.terms_accepted_at
        existing_customer.update(name: "Updated Customer")
        expect(existing_customer.terms_accepted_at).to eq(original_terms_accepted_at)
      end
    end
  end
end
