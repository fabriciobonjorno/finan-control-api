# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module Register
        class Contract < ApplicationContract
          params do
            required(:document).filled(:str?)
            required(:legal_name).filled(:str?)
            required(:trade_name).filled(:str?)
            required(:first_name).filled(:str?)
            required(:last_name).filled(:str?)
            required(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
            required(:password).filled(:str?, format?: /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{8,}\z/)
            required(:password_confirmation).filled(:str?)
          end

          rule(:document) do
            key.failure(I18n.t("api.auth.document")) unless CNPJ.valid?(values[:document])
          end

          rule(:password_confirmation) do
            key.failure(I18n.t("api.auth.password_confirmation")) if values[:password] != values[:password_confirmation]
          end
        end
      end
    end
  end
end
