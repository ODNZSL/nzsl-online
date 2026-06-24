# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def email(model)
    @feedback = model
    attachments[@feedback.video_file_name] = File.read(@feedback.video.path) if @feedback.video_file_name
    mail(to: CONTACT_EMAIL, subject: 'NZSL Website Feedback')
  end
end
