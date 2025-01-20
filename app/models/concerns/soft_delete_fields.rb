# frozen_string_literal: true

module SoftDeleteFields
    extend ActiveSupport::Concern

    def soft_delete
      update(deleted_at: Time.current)
    end

    def activate_deleted_at
      self.update(deleted_at: nil)
    end
end
