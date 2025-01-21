# frozen_string_literal: true

class Api::V1::AuthController < ApplicationController
  def get_document
    Api::V1::AuthServices::GetDocument::UseCase.call(params) do |on|
      on.failure(:validate_params) { |output_message| render json: { message: output_message }, status: 400 }
      on.failure(:find_document) { |output_message| render json: { message: output_message }, status: 400 }
      on.failure(:output) { |output_message| render json: { message: output_message }, status: 400 }
      on.failure { |response| render json: response, status: 500 }
      on.success { |output_message, user_data| render json: { message: output_message, data: user_data }, status: 200 }
    end
  end
end
