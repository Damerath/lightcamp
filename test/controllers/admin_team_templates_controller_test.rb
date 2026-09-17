require "test_helper"

class AdminTeamTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "management users can assign a responsible contact in the team template detail view" do
    sign_in_as("leader")
    contact = User.create!(
      email: "contact-#{SecureRandom.uuid}@example.com",
      password: "test-password",
      role: "leader",
      first_name: "Kontakt",
      last_name: "Person",
      gender: "divers",
      birthdate: Date.new(1990, 1, 1),
      phone: "0123456789"
    )
    template = TeamTemplate.create!(name: "Kueche #{SecureRandom.uuid}")

    get admin_team_template_path(template)
    assert_response :success
    assert_select "label", text: "Verantwortlich:"

    patch admin_team_template_path(template), params: {
      section: "description",
      team_template: { responsible_user_id: contact.id }
    }

    assert_redirected_to admin_team_template_path(template, section: "description")
    assert_equal contact, template.reload.responsible_user
  end
end
