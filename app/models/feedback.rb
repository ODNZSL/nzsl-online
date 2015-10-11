##
# Sends feedback email
class Feedback < ActiveRecord::Base
  validates :name, :message, presence: true
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      allow_nil: true

  has_attached_file :video,
                    url: '/no-video',
                    path: ':rails_root/data/uploaded/feedback/:id/:basename.:extension'

  validates_attachment_size :video, less_than: 50.megabytes, allow_nil: true

  def send_email
    FeedbackMailer.email(self).deliver
    self.video = nil
    save
  rescue
    return false
  end
end
