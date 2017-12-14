namespace :vocab_sheets do
  task clear: :environment do
    VocabSheet.clear_vocab_sheet
  end
end
