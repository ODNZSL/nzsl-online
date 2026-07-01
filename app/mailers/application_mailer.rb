# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.app.mail_from
  default to: ADMIN_EMAIL
  layout 'mailer'
end
