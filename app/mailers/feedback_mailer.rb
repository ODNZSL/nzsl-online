# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def email(model)
    @feedback = model
    attachments[@feedback.video.filename.to_s] = @feedback.video.download if @feedback.video.attached?
    mail(to: CONTACT_EMAIL, subject: "NZSL Website Feedback", reply_to: @feedback.email) # rubocop:todo Rails/I18nLocaleTexts
  end
end
