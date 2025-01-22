# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module Register
        class UseCase < MainService
          step :validate_params
          step :check_document
          step :check_email
          step :output

          def validate_params(params)
            validation = Contract.call(params.permit!.to_h)
            return Success(params) if validation.success?

            Failure(format_errors(validation.errors.to_h))
          end

          def check_document(params)
            document = CNPJ.new(params[:document]).stripped
            response = fetch_company_data(document)

            return Failure(I18n.t("api.auth.company_not_found")) if response.blank?

            status = response.dig("estabelecimento", "situacao_cadastral")
            return Failure(I18n.t("api.auth.company_status", status: status)) unless status == "Ativa"

            Success(response)
          end

          def check_email(params)
            document = CNPJ.new(params[:document]).stripped
            response = fetch_company_data(document)

            return Failure(I18n.t("api.auth.company_not_found")) if response.blank?

            status = response.dig("estabelecimento", "situacao_cadastral")
            return Failure(I18n.t("api.auth.company_status", status: status)) unless status == "Ativa"

            Success(response)
          end

          def method_name
            
          end

          def output(result)
            response = Presenter.call(result)
            return Success([ I18n.t("api.auth.company_found"), response ]) if response

            Failure(I18n.t("api.auth.company_not_found"))
          end

          private

          def fetch_company_data(document)
            Util.company_data(document)
          end
        end
      end
    end
  end
end
