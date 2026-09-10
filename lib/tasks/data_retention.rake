namespace :data_retention do
  desc "Remove expired personal data and anonymize archived camp applications"
  task apply: :environment do
    DataRetention.run!
  end
end
