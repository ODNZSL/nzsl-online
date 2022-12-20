# Update the dictionary file if it is older than 1 month
# We update this file in both dictionary modes because our tests
# expect the database to test across both modes
path = Rails.root.join('db', 'dictionary.sqlite3')
Rails.application.load_tasks
Rake::Task['dictionary:update'].execute if !path.exist? || path.mtime <= 1.month.ago
