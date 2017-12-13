namespace :vocab_sheets do
  MAX_DAYS = 31

  desc 'Clears all vocab sheets that are more than one month old'
  task clear: :environment do
    total_destroyed = 0
    total_destroyed += VocabSheet.where('created_at < ?', MAX_DAYS.days.ago).destroy_all.length

    puts "A total of #{total_destroyed} vocabulary sheets were deleted, #{VocabSheet.count} remaining"\
         "Remaining vocabulary sheets are those made since #{MAX_DAYS.days.ago}."
  end
end
