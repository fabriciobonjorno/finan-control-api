# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { build(:role) }

  describe "associations" do
    it { should belong_to(:company) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:key) }
    it { should define_enum_for(:status).with_values({ active: 0, inactive: 1 }) }
 end

 describe "soft delete" do
  it "sets deleted_at when soft_delete is called" do
    role.save
    role.soft_delete
    expect(role.deleted_at).not_to be_nil
  end

  it "reactivates a soft-deleted account" do
    role.save
    role.soft_delete
    role.activate_deleted_at
    expect(role.deleted_at).to be_nil
  end
end

 describe "normalization" do
    it "removes numbers and trims spaces from name and key" do
      role = build(:role, name: " Admin123 ", key: " 4admin56 ")
      role.valid?
      expect(role.name).to eq("Admin")
      expect(role.key).to eq("admin")
    end

    it "does not change already normalized values" do
      role = build(:role, name: "Admin", key: "admin")
      role.valid?
      expect(role.name).to eq("Admin")
      expect(role.key).to eq("admin")
    end
  end
end
