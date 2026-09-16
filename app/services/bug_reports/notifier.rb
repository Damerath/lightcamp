module BugReports
  class Notifier
    class << self
      def report_created!(report)
        User.where(role: "admin").find_each do |admin|
          BugReportMailer.new_report(admin: admin, bug_report: report).deliver_now
        rescue StandardError => error
          Rails.logger.error("Bugreport email for admin #{admin.id} failed: #{error.class}: #{error.message}")
        end
      end

      def report_resolved!(report, actor:)
        Notifications::Publisher.publish!(
          key: "bug_report_resolved",
          actor: actor,
          metadata: { bug_report_id: report.id },
          deliveries: [
            {
              user: report.user,
              title: "Bugreport gelöst",
              body: "Dein Bugreport ##{report.id} (#{report.title}) wurde als gelöst markiert.",
              link_url: Rails.application.routes.url_helpers.root_path
            }
          ]
        )
      end
    end
  end
end
