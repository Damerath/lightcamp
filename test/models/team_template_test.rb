require "test_helper"

class TeamTemplateTest < ActiveSupport::TestCase
  test "accepts a leadership user as responsible contact" do
    contact = create_user(role: "leader")
    template = TeamTemplate.new(name: "Testbereich #{SecureRandom.uuid}", responsible_user: contact)

    assert_predicate template, :valid?
  end

  test "rejects a non-management user as responsible contact" do
    contact = create_user(role: "user")
    template = TeamTemplate.new(name: "Testbereich #{SecureRandom.uuid}", responsible_user: contact)

    assert_not_predicate template, :valid?
    assert_includes template.errors[:responsible_user], "muss eine Leitungsperson oder ein Admin sein"
  end

  private

  def create_user(role:)
    User.create!(
      email: "#{role}-#{SecureRandom.uuid}@example.com",
      password: "test-password",
      role: role,
      first_name: "Test",
      last_name: "Kontakt",
      gender: "divers",
      birthdate: Date.new(1990, 1, 1),
      phone: "0123456789"
    )
  end
end
