# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  before_create :generate_uuid_v7


  private

  def generate_uuid_v7
    return unless self.class.attribute_types["id"]&.type == :uuid
    self.id ||= SecureRandom.uuid_v7
  end
end
