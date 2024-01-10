Rails.application.reloader.to_prepare do
  # Update the dictionary file on boot
  Rails.application.load_tasks
  deployed = !Rails.env.development? && !Rails.env.test?

  begin
    Rake::Task["dictionary:update"].execute if deployed
  rescue StandardError => e
    warn e
  end

  ##
  # All other tables make heavy use of a 'word' column. Add an alias for it here so that
  # we can use common queries and ordering.
  # There's no ADD COLUMN IF NOT EXISTS, so we just handle the error
  begin
    DictionarySign.connection.execute("ALTER TABLE words ADD COLUMN word text AS (gloss)")
  rescue ActiveRecord::StatementInvalid => e
    raise e unless e.message == "SQLite3::SQLException: duplicate column name: word"
  end
end
