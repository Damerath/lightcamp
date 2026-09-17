namespace :leadership_annual_tasks do
  desc "Reactivate annual tasks and send due reminder emails"
  task process_reminders: :environment do
    LeadershipAnnualTasks::ReminderRunner.run!
    puts "Leadership annual tasks processed."
  end
end
