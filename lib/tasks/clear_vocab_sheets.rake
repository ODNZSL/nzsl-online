# frozen_string_literal: true

namespace :vocab_sheets do
  task clear: :environment do
    VocabSheet.purge_old_sheets
  end

  task aggressively_clear: :environment do
    VocabSheet.aggressively_purge_old_sheets
  end
end
