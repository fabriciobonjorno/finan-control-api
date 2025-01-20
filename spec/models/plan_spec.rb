# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  subject(:plan) { build(:plan) }

  describe "associations" do
    it { should have_many(:customers).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:max_users) }
    it { should validate_presence_of(:max_companies) }
    it { should validate_presence_of(:plan_price) }
    it { should validate_presence_of(:plan_type) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should define_enum_for(:status).with_values({ active: 0, inactive: 1 }) }
    it { should define_enum_for(:plan_type).with_values({ free: 0, monthly: 1, semi_annual: 2, annual: 3 }) }
  end

  describe "soft delete" do
    it "sets deleted_at when soft_delete is called" do
      plan.save
      plan.soft_delete
      expect(plan.deleted_at).not_to be_nil
    end

    it "reactivates a soft-deleted account" do
      plan.save
      plan.soft_delete
      plan.activate_deleted_at
      expect(plan.deleted_at).to be_nil
    end
  end

  describe "normalization" do
    it "removes numbers and trims spaces from name" do
      plan = build(:plan, name: " Gold123 ")
      plan.valid?
      expect(plan.name).to eq("Gold")
    end

    it "does not change already normalized values" do
      plan = build(:plan, name: "Gold")
      plan.valid?
      expect(plan.name).to eq("Gold")
    end
  end
end
