# frozen_string_literal: true

module Api
  module V1
    module AuthServices
      module Onboarding
        class UseCase < MainService
          step :validate_params
          step :check_document
          step :check_email
          step :build_onboard_data
          step :output

          def validate_params(params)
            validation = Contract.call(params.permit!.to_h)
            return Success(params) if validation.success?

            Failure(format_errors(validation.errors.to_h))
          end

          def check_document(params)
            document = CNPJ.new(params[:document]).stripped
            return Failure(I18n.t("api.auth.document_already_registered")) if Company.exists?(document: document)

            Success(params)
          end

          def check_email(params)
            return Failure(I18n.t("api.auth.email_already_registered")) if User.exists?(email: params[:email])

            Success(params)
          end

          def build_onboard_data(params)
            plan = find_plan(params[:plan_id])
            return Failure(I18n.t("api.auth.plan_not_found")) unless plan

            customer, company, user, role = build_associations(params, plan)
            errors = collect_errors(customer, company, user, role)

            return Failure(errors) unless errors.empty?

            if customer.save
              send_confirmation_email(user)
              UserCompanyRole.create(user_id: user.id, company_id: company.id, role_id: role.id)
              Success(customer)
            else
              Failure(I18n.t("api.auth.company_creation_failed"))
            end
          end

          def output(result)
            response = Presenter.call(result)
            return Success([ I18n.t("api.auth.company_created"), response ]) if response

            Failure(I18n.t("api.auth.company_creation_failed"))
          end

          def output(result)
            response = Presenter.call(result)
            return Success([ I18n.t("api.auth.company_created"), response ]) if response

            Failure(I18n.t("api.auth.company_creation_failed"))
          end

          private

          def find_plan(plan_id)
            Plan.find_by(id: plan_id)
          end

          def build_associations(params, plan)
            customer = Customer.new(
              name: customer_name(params),
              terms_accepted: params[:terms_accepted],
              plan_id: plan.id,
              plan_start_date: Date.today,
              plan_end_date: calculate_end_date(plan)
            )

            company = customer.companies.build(
              document: params[:document],
              legal_name: params[:legal_name],
              trade_name: params[:trade_name]
            )

            user = customer.users.build(
              email: params[:email],
              first_name: params[:first_name],
              last_name: params[:last_name],
              password: params[:password],
              password_confirmation: params[:password_confirmation]
            )

            role = company.roles.build(name: "Admin", key: "admin")

            [ customer, company, user, role ]
          end

          def collect_errors(*models)
            models.flat_map { |model| model.errors.full_messages if model.invalid? }.compact
          end

          def customer_name(params)
            Util.normalize_customer_name(params[:document], params[:legal_name])
          end

          def calculate_end_date(plan)
            case plan.plan_type
            when :free, :monthly then Date.today + 1.month
            when :quarterly then Date.today + 3.months
            when :semi_annually then Date.today + 6.months
            when :annually then Date.today + 1.year
            else Date.today
            end
          end

          def send_confirmation_email(user)
            user.generate_confirmation_token
            Thread.new { ApplicationMailer.send_confirmation_token(user).deliver }
          end
        end
      end
    end
  end
end
