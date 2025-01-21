# frozen_string_literal: true

class MainService
    include Dry::Transaction
    include Dry::Monads[:result]

    def self.call(*args, &block)
      new.call(*args, &block)
    end

    RETURNS = [
      SUCCESS = :success,
      FAILURE = :failure
    ].freeze

    def format_errors(errors)
      errors.flat_map { |_, messages| messages }.join(", ")
    end
end
