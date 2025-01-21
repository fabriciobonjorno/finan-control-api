# frozen_string_literal: true

class User < ApplicationRecord
  include SoftDeleteFields
  include CryptableFields
  attr_accessor :account_validation
  has_secure_password

  before_save :capitalize_name, if: -> { will_save_change_to_first_name? || will_save_change_to_last_name? }

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_regex

  with_options if: -> { account_validation } do
    validates :birth_date, :partner_type, :document, presence: true
    validates :document, uniqueness: { case_sensitive: false }
    validate :valid_document
  end

  normalizes :email, with: -> { _1.strip.downcase }
  normalizes :first_name, :last_name, with: -> { _1.gsub(/\d/, " ").strip }
  normalizes :document, with: -> { CPF.new(_1).stripped }

  enum :partner_type, %i[partner proxyholder legal_representative other]

  belongs_to :customer

  def generate_confirmation_token
    update_columns(confirmation_token: SecureRandom.urlsafe_base64, confirmation_sent_at: Time.now)
  end

  def confirmation_token_is_valid?
    confirmation_token.present? && confirmation_sent_at + 24.hours >= Time.now
  end

  def reset_confirmation_token
    update_columns(confirmation_token: nil, confirmation_sent_at: nil)
  end

  def generate_reset_password_token
    update_columns(reset_password_token: SecureRandom.urlsafe_base64, reset_password_sent_at: Time.now)
  end
  def reset_token_is_valid?
    reset_password_token.present? && reset_password_sent_at + 24.hours >= Time.now
  end

  def reset_reset_password_token
    update_columns(reset_password_token: nil, reset_password_sent_at: nil)
  end

  def confirm_account
    self.update(confirmed: true)
  end

  def update_login_failed_attempts
    increment_failed_attempts(:login_failed_attempts)
  end

  def reset_login_failed_attempts
    reset_failed_attempts(:login_failed_attempts)
  end

  def update_token_failed_attempts
    increment_failed_attempts(:token_failed_attempts)
  end

  def reset_token_failed_attempts
    reset_failed_attempts(:token_failed_attempts)
  end

  def update_transaction_failed_attempts
    increment_failed_attempts(:transaction_failed_attempts)
  end

  def reset_transaction_failed_attempts
    reset_failed_attempts(:transaction_failed_attempts)
  end

  private

  def valid_document
    errors.add(:document, "invalid document") unless CPF.valid?(document)
  end

  def capitalize_name
    self.first_name = Util.capitalize_name(first_name)
    self.last_name = Util.capitalize_name(last_name)
  end

  def password_regex
    return if password.blank? || Util.password_regex(password)

    errors.add(:password, "mínimo 8 caracteres, incluindo 1 letra maiúscula, 1 número, 1 caractere especial")
  end

  def increment_failed_attempts(field)
    increment!(field)
    lock_account if public_send(field) >= 3
  end

  def reset_failed_attempts(field)
    update_columns(field => 0, locked: false, locked_at: nil)
  end

  def lock_account
    update_columns(locked: true, locked_at: Time.now)
  end
end
