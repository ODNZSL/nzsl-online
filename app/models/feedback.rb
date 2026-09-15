# frozen_string_literal: true

##
# Sends feedback email
class Feedback < ApplicationRecord
  validates :name, :message, presence: true
  validates :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                    allow_nil: true

  has_one_attached :video

  validate :video_size_within_limit

  def send_email
    FeedbackMailer.email(self).deliver
    video.purge
    save
  rescue StandardError
    false
  end

  private

  def video_size_within_limit
    return unless video.attached?

    errors.add(:video, "is too large") if video.blob.byte_size >= 50.megabytes
  end
end
