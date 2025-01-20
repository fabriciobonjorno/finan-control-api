# frozen_string_literal: true

class Plan < ApplicationRecord
    include SoftDeleteFields
    before_save :capitalize_name

    validates :name, :status, :max_users, :max_companies, :free_price, :monthly_price, :semi_annual_price, :annual_price, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    normalizes :name, with: -> { _1.gsub(/\d/, "").strip }

    enum :status, %i[active inactive]

    private

    def capitalize_name
      self.name = Util.capitalize_name(name) if name_changed?
    end
end
