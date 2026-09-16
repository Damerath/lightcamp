require "test_helper"

class Notifications::DigestSenderTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  setup { ActionMailer::Base.deliveries.clear }

  test "sends all notifications from a due two-hour window in one email" do
    user = User.create!(email: "digest@example.com", password: "test-password", first_name: "Peter")

    start_time = Time.zone.local(2026, 9, 16, 10, 0, 0)

    travel_to start_time do
      publish_notification(user, title: "Neue Datei", body: "Ein Ablaufplan wurde hochgeladen.")
    end

    travel_to start_time + 1.hour do
      publish_notification(user, title: "Neue Aufgabe", body: "Bitte prüfe die Materialliste.")
    end

    Notifications::DigestSender.run!(now: start_time + 2.hours)

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_includes ActionMailer::Base.deliveries.last.body.encoded, "Hallo Peter"
    assert_includes ActionMailer::Base.deliveries.last.body.encoded, "Neue Datei"
    assert_includes ActionMailer::Base.deliveries.last.body.encoded, "Neue Aufgabe"
    assert_equal 2, user.notification_deliveries.channel_kind_email.status_delivered.count
  end

  test "does not send before the two-hour window ends" do
    user = User.create!(email: "not-due@example.com", password: "test-password")

    travel_to Time.zone.local(2026, 9, 16, 10, 0, 0) do
      publish_notification(user, title: "Neue Datei", body: "Ein Ablaufplan wurde hochgeladen.")

      Notifications::DigestSender.run!(now: Time.current + 1.hour)

      assert_empty ActionMailer::Base.deliveries
      assert_equal 1, user.notification_deliveries.channel_kind_email.status_created.count
    end
  end

  private

  def publish_notification(user, title:, body:)
    Notifications::Publisher.publish!(
      key: "test_notification",
      deliveries: [{ user: user, title: title, body: body, link_url: "/" }]
    )
  end
end
