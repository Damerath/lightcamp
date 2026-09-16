ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # Mehrere geschützte Seiten verlangen ein vollständiges Profil. Testnutzer
  # erhalten daher direkt alle dafür notwendigen Angaben.
  def sign_in_as(role = "user")
    user = User.create!(
      email: "#{role}-#{SecureRandom.uuid}@example.com",
      password: "test-password",
      role: role,
      first_name: "Test",
      last_name: "User",
      gender: "divers",
      birthdate: Date.new(1990, 1, 1),
      phone: "0123456789"
    )

    sign_in user
    user
  end
end
