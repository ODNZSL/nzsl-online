namespace :feedback_videos do
  desc "Migrates feedback videos from paperclip to activestorage"
  task migrate_to_activestorage: :environment do
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
end
