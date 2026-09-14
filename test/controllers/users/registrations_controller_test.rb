require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "rejects registrations that fill the honeypot" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          first_name: "Bot",
          last_name: "Account",
          email: "bot@example.com",
          password: "secure-password",
          password_confirmation: "secure-password"
        },
        website: "https://spam.example"
      }
    end

    assert_response :unprocessable_entity
    assert_equal "Die Sicherheitsprüfung ist fehlgeschlagen. Bitte versuche es erneut.", flash[:alert]
  end

  test "rejects a registration without a Turnstile token" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          first_name: "Test",
          last_name: "Person",
          email: "test-person@example.com",
          password: "secure-password",
          password_confirmation: "secure-password"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_equal "Die Sicherheitsprüfung ist fehlgeschlagen. Bitte versuche es erneut.", flash[:alert]
  end
end
