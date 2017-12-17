namespace :vocab_sheets do
  task clear: :environment do
    VocabSheet.purge_old_sheets
  end
end
