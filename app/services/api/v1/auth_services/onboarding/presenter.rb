# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module Onboarding
        class Presenter < MainService
          def call(result)
            {
              legal_name: result.companies.first.legal_name,
              trade_name: result.companies.first.trade_name,
              document: CNPJ.format(result.companies.first.document),
              plan: result.plan.name,
              plan_start_date: result.plan_start_date,
              plan_end_date: result.plan_end_date
            }
          end
        end
      end
    end
  end
end
