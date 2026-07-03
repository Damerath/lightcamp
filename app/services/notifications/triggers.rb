module Notifications
  module Triggers
    module_function

    def camp_activated!(year:, actor: nil)
      deliveries = users_without(actor).map do |user|
        {
          user: user,
          title: "Anmeldung geöffnet",
          body: "Die Anmeldung für die Camps #{year.name} ist jetzt geöffnet.",
          link_url: routes.camp_application_path
        }
      end

      ::Notifications::Publisher.publish!(key: "camp_activated", actor: actor, metadata: { year_id: year.id }, deliveries: deliveries)
    end

    def team_assignment_updated!(camp_application:, actor: nil)
      assigned_team = camp_application.assigned_camp_team
      return if assigned_team.blank?

      workspace_team = assigned_team.workspace_team
      role_suffix = camp_application.assigned_as_responsible? ? " als verantwortliche Person" : ""

      ::Notifications::Publisher.publish!(
        key: "team_assignment_updated",
        actor: actor,
        metadata: { camp_application_id: camp_application.id, camp_team_id: assigned_team.id },
        deliveries: [
          {
            user: camp_application.user,
            title: "Teamzuteilung aktualisiert",
            body: "Du wurdest dem Team #{workspace_team.workspace_label} in #{assigned_team.camp.name} #{assigned_team.camp.year.name}#{role_suffix} zugeteilt.",
            link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team)
          }
        ]
      )
    end

    def team_meeting_changed!(camp_team:, actor: nil, changed: :updated)
      return if camp_team.next_internal_meeting_at.blank?

      verb = changed == :created ? "ein neuer Teamtermin eingetragen" : "ein Teamtermin aktualisiert"

      ::Notifications::Publisher.publish!(
        key: "team_meeting_changed",
        actor: actor,
        metadata: { camp_team_id: camp_team.id, change_kind: changed.to_s },
        deliveries: team_member_deliveries(camp_team, actor: actor) do |workspace_team, _user|
          {
            title: "Teamtermin geändert",
            body: "Im Team #{workspace_team.workspace_label} #{workspace_team.camp.name} #{workspace_team.camp.year.name} wurde #{verb}.",
            link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team)
          }
        end
      )
    end

    def team_download_added!(camp_team:, download_item:, actor: nil)
      ::Notifications::Publisher.publish!(
        key: "team_download_added",
        actor: actor,
        metadata: { camp_team_id: camp_team.id, download_item_id: download_item.id },
        deliveries: team_member_deliveries(camp_team, actor: actor) do |workspace_team, _user|
          {
            title: "Neue Team-Datei",
            body: "Im Team #{workspace_team.workspace_label} #{workspace_team.camp.name} #{workspace_team.camp.year.name} wurde eine neue Datei hochgeladen: #{download_item.title}.",
            link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team, section: "downloads")
          }
        end
      )
    end

    def team_link_added!(camp_team:, link:, actor: nil)
      ::Notifications::Publisher.publish!(
        key: "team_link_added",
        actor: actor,
        metadata: { camp_team_id: camp_team.id, camp_team_link_id: link.id },
        deliveries: team_member_deliveries(camp_team, actor: actor) do |workspace_team, _user|
          {
            title: "Wichtiger Team-Link",
            body: "Im Team #{workspace_team.workspace_label} #{workspace_team.camp.name} #{workspace_team.camp.year.name} wurde ein wichtiger Link ergänzt: #{link.title}.",
            link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team)
          }
        end
      )
    end

    def team_todo_added!(camp_team:, todo:, actor: nil)
      ::Notifications::Publisher.publish!(
        key: "team_todo_added",
        actor: actor,
        metadata: { camp_team_id: camp_team.id, camp_team_todo_id: todo.id },
        deliveries: team_member_deliveries(camp_team, actor: actor) do |workspace_team, _user|
          {
            title: "Neue Team-ToDo",
            body: "Im Team #{workspace_team.workspace_label} #{workspace_team.camp.name} #{workspace_team.camp.year.name} wurde eine neue Aufgabe angelegt: #{todo.title}.",
            link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team, section: "todos")
          }
        end
      )
    end

    def week_plan_published!(program_team:, actor: nil)
      camp = program_team.camp
      applications = camp.assigned_camp_applications.includes(:user, :assigned_camp_team).where.not(assigned_camp_team_id: nil)

      deliveries = applications.filter_map do |application|
        next if application.user_id == actor&.id
        next if application.assigned_camp_team_id == program_team.id

        workspace_team = application.assigned_camp_team.workspace_team
        {
          user: application.user,
          title: "Wochenplan veröffentlicht",
          body: "Für #{camp.name} #{camp.year.name} wurde der Wochenplan veröffentlicht.",
          link_url: routes.camp_team_page_path(workspace_team.camp, workspace_team, section: "week_plan")
        }
      end

      ::Notifications::Publisher.publish!(
        key: "week_plan_published",
        actor: actor,
        metadata: { camp_id: camp.id, camp_team_id: program_team.id },
        deliveries: deliveries
      )
    end

    def routes
      Rails.application.routes.url_helpers
    end

    def users_without(actor)
      scope = User.all.order(:id)
      actor.present? ? scope.where.not(id: actor.id) : scope
    end

    def team_member_deliveries(camp_team, actor: nil)
      workspace_team = camp_team.workspace_team

      workspace_team.assigned_workspace_applications.includes(:user).filter_map do |application|
        user = application.user
        next if user.blank?
        next if user.id == actor&.id

        payload = yield(workspace_team, user)
        payload.merge(user: user)
      end.uniq { |entry| entry[:user].id }
    end
  end
end
