require "test_helper"

class DeviseMailerTest < ActionMailer::TestCase
  test "password reset email is sent in German" do
    user = User.create!(email: "mail-test@example.com", password: "test-password", first_name: "Peter")

    mail = Devise::Mailer.reset_password_instructions(user, "reset-token")

    assert_equal "Anweisungen zum Zurücksetzen des Passworts", mail.subject
    assert_includes mail.body.encoded, "Hallo Peter"
    assert_includes mail.body.encoded, "Passwort zurücksetzen"
    assert_includes mail.body.encoded, "Falls du dies nicht angefordert hast"
  end
end
