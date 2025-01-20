# frozen_string_literal: true

class Plan < ApplicationRecord
    include SoftDeleteFields
    before_save :capitalize_name

    validates :name, :status, :max_users, :max_companies, :plan_type, :plan_price, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    normalizes :name, with: -> { _1.gsub(/\d/, "").strip }

    enum :status, %i[active inactive]
    enum :plan_type, %i[free monthly semi_annual annual]

    has_many :customers, dependent: :restrict_with_error

    private

    def capitalize_name
      self.name = Util.capitalize_name(name) if name_changed?
    end
end
