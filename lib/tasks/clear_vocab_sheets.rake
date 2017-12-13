namespace :clear_vocab_sheets do
  STORAGE_DAYS = 31

  desc 'Clears all vocab sheets that are more than one month old'
  task manage_requests: :environment do
    total_destroyed = 0
    # Delete requests over STORAGE_DAYS days old
    total_destroyed += VocabSheet.where('created_at < ?', STORAGE_DAYS.days.ago).destroy_all.length

    puts "A total of #{total_destroyed} vocabulary sheets were deleted, #{VocabSheet.count} remaining"\
         "Remaining vocabulary sheets are those made since #{STORAGE_DAYS.days.ago}."
  end
end
