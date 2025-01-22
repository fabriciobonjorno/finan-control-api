# frozen_string_literal: true

class Role < ApplicationRecord
  include SoftDeleteFields

  validates :name, :key, presence: true
  validates :name, :key, uniqueness: { case_sensitive: false, scope: :company }

  normalizes :name, :key, with: -> { _1.gsub(/\d/, " ").strip }

  enum :status, %i[active inactive]

  belongs_to :company
end
