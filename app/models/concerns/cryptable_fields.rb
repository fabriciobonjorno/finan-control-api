# frozen_string_literal: true

module CryptableFields
    include BCrypt
    extend ActiveSupport::Concern

    def sms_token
      Password.new(sms_hash)
    end

    def sms_token=(new_password)
      self.sms_hash = Password.create(new_password)
    end

    def email_token
      Password.new(email_hash)
    end

    def email_token=(new_password)
      self.email_hash = Password.create(new_password)
    end

    def transaction_token
      Password.new(transaction_hash)
    end

    def transaction_token=(new_password)
      self.transaction_hash = Password.create(new_password)
    end
end
