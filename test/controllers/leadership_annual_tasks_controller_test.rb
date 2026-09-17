require "test_helper"

class LeadershipAnnualTasksControllerTest < ActionDispatch::IntegrationTest
  test "only management users can access annual tasks" do
    sign_in_as("user")

    get leadership_annual_tasks_path

    assert_redirected_to root_path
  end

  test "leaders can create and view annual tasks" do
    responsible_user = sign_in_as("leader")

    get leadership_annual_tasks_path
    assert_response :success

    post leadership_annual_tasks_path, params: {
      leadership_annual_task: {
        title: "Mitarbeiteranmeldung",
        responsible_user_id: responsible_user.id,
        due_day: 15,
        due_month: 10,
        reactivation_day: 1,
        reactivation_month: 8,
        active: "1"
      }
    }

    task = LeadershipAnnualTask.find_by!(title: "Mitarbeiteranmeldung")
    assert_redirected_to leadership_annual_task_path(task)

    get leadership_annual_task_path(task)
    assert_response :success
    assert_select "h2", text: "Mitarbeiteranmeldung"

    task.reminders.create!(days_before: 15)
    get leadership_annual_task_path(task, modal: "edit")
    assert_response :success
    assert_select "span", text: "15 Tage vorher"
  end
end
