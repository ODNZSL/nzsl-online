class ApplicationMailer < ActionMailer::Base
  default from: 'website@nzsl.vuw.ac.nz'
  default to: ADMIN_EMAIL
  layout 'mailer'
end