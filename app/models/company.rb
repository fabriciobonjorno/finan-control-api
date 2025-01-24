# frozen_string_literal: true

class Company < ApplicationRecord
  include SoftDeleteFields
  include CryptableFields
  attr_accessor :account_validation

  before_save :capitalize_name

  validates :legal_name, :trade_name, :document, presence: true
  validates :document, presence: true, uniqueness: { case_sensitive: false }

  with_options if: -> { account_validation } do
    validates :founding_date, :business_type, :main_activity, :email, presence: true
    validates :email, uniqueness: { case_sensitive: false }
  end

  validate :valid_document

  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :legal_name, :trade_name, with: -> { _1.gsub(/\d/, "").strip }
  normalizes :document, with: -> { CNPJ.new(_1).stripped }

  enum :business_type, %i[EI MEI EPP EIRELI LTDA SA_OPEN SA_CLOSED]

  belongs_to :customer
  has_many :roles, dependent: :restrict_with_error
  has_many :user_company_roles, dependent: :restrict_with_error
  has_many :users, through: :user_company_roles

  private

  def valid_document
    errors.add :base, "invalid document" unless CNPJ.valid?(document)
  end

  def capitalize_name
    self.legal_name = Util.capitalize_name(legal_name) if legal_name_changed?
    self.trade_name = Util.capitalize_name(trade_name) if trade_name_changed?
  end
end
