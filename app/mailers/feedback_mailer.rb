class FeedbackMailer < ActionMailer::Base
  default :from => "website@nzsl.vuw.ac.nz"
  default :to => ADMIN_EMAIL
  
  def email(model)
    @feedback = model
    attachments[@feedback.video_file_name] = File.read(@feedback.video.path) if @feedback.video_file_name
    mail(:subject => "NZSL Website Feedback")
  end
end
