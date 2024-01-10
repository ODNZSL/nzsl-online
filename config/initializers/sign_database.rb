Rails.application.reloader.to_prepare do
  # Update the dictionary file on boot
  Rails.application.load_tasks
  Rake::Task['dictionary:update'].execute
end
