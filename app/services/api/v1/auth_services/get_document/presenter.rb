# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module GetDocument
        class Presenter < MainService
          def call(result)
            {
              legal_name: result["razao_social"],
              trade_name: result.dig("estabelecimento", "nome_fantasia"),
              document: CNPJ.format(result.dig("estabelecimento", "cnpj"))
            }
          end
        end
      end
    end
  end
end
