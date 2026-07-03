namespace :notifications do
  desc "Send in-app reminder notifications for team meetings and training dates"
  task send_reminders: :environment do
    Notifications::Reminders.run!
    puts "Reminder notifications processed."
  end
end
