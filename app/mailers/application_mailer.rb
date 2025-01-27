# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def send_confirmation_token(user)
    @user = user
    mail(
      from: ENV["EMAIL_DEFAULT"],
      to: @user.email,
      subject: "Email de confirmação"
    )
  end
end
