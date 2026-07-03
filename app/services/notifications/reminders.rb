module Notifications
  class Reminders
    class << self
      def run!(target_date: Date.current + 7.days)
        send_team_meeting_reminders!(target_date: target_date)
        send_training_reminders!(target_date: target_date)
      end

      def send_team_meeting_reminders!(target_date:)
        CampTeam.includes(camp: :year)
          .where.not(next_internal_meeting_at: nil)
          .find_each do |camp_team|
          next unless camp_team.next_internal_meeting_at.to_date == target_date
          next if reminder_sent?(key: "team_meeting_reminder", metadata: { camp_team_id: camp_team.id, target_date: target_date.iso8601 })

          ::Notifications::Publisher.publish!(
            key: "team_meeting_reminder",
            metadata: { camp_team_id: camp_team.id, target_date: target_date.iso8601 },
            deliveries: ::Notifications::Triggers.team_member_deliveries(camp_team) do |workspace_team, _user|
              {
                title: "Teamtermin-Erinnerung",
                body: "Erinnerung: Der Teamtermin im Team #{workspace_team.workspace_label} #{workspace_team.camp.name} #{workspace_team.camp.year.name} ist in einer Woche (#{I18n.l(camp_team.next_internal_meeting_at.to_date, format: '%d.%m.%Y')}).",
                link_url: ::Notifications::Triggers.routes.camp_team_page_path(workspace_team.camp, workspace_team)
              }
            end
          )
        end
      end

      def send_training_reminders!(target_date:)
        Year.where(training_on: target_date).find_each do |year|
          metadata = { year_id: year.id, target_date: target_date.iso8601 }
          next if reminder_sent?(key: "training_reminder", metadata: metadata)

          deliveries = User.order(:id).map do |user|
            {
              user: user,
              title: "Schulungs-Erinnerung",
              body: "Erinnerung: Die Lightcamp-Schulung für #{year.name} ist in einer Woche (#{I18n.l(year.training_on, format: '%d.%m.%Y')}). Bitte meld dich ab, wenn du nicht dabei sein kannst!",
              link_url: ::Notifications::Triggers.routes.root_path
            }
          end

          ::Notifications::Publisher.publish!(
            key: "training_reminder",
            metadata: metadata,
            deliveries: deliveries
          )
        end
      end

      private

      def reminder_sent?(key:, metadata:)
        NotificationEvent.where(key: key).where("metadata @> ?", metadata.to_json).exists?
      end
    end
  end
end
