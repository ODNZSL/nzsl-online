# Conditionally switch between dictionary sign models based on an environment variable.
# This allows us to quickly switch between searching Freelex and Signbank data for signs.
return if SignModel.freelex?

# Update the dictionary file if it is older than 1 month
path = Rails.root.join('db', 'dictionary.sqlite3')
Rails.application.load_tasks
Rake::Task['dictionary:update'].execute if !path.exist? || path.mtime <= 1.month.ago
