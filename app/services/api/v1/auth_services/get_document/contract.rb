# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module GetDocument
        class Contract < ApplicationContract
          params do
            required(:document).filled(:string)
          end

          rule(:document) do
            key.failure(I18n.t("api.auth.document")) unless CPF.valid?(values[:document]) || CNPJ.valid?(values[:document])
          end
        end
      end
    end
  end
end
