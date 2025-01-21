# frozen_string_literal: true

class Customer < ApplicationRecord
  include SoftDeleteFields
  before_save :set_terms_accepted_at

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :terms_accepted, presence: { message: "Para continuar, você precisa concordar com os termos" }

  belongs_to :plan
  has_many :companies, dependent: :restrict_with_error
  has_many :users, dependent: :restrict_with_error

  private

  def set_terms_accepted_at
    self.terms_accepted_at = Time.current if new_record?
  end
end
