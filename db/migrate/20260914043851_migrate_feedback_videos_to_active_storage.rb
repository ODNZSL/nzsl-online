# frozen_string_literal: true

class MigrateFeedbackVideosToActiveStorage < ActiveRecord::Migration[8.1]
  class Feedback < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    has_one_attached :video
  end

  def up
    Feedback.where.not(video_file_name: nil).find_each do |feedback|
      path = Rails.root.join("data", "uploaded", "feedback", feedback.id.to_s, feedback.video_file_name)
      next unless File.exist?(path)

      File.open(path, "rb") do |file|
        feedback.video.attach(
          io: file,
          filename: feedback.video_file_name,
          content_type: feedback.video_content_type
        )
      end
    end
  end

  def down
    Feedback.find_each { |feedback| feedback.video.purge }
  end
end
