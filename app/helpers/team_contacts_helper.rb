module TeamContactsHelper
  def team_contact_phone_href(phone)
    normalized_team_contact_phone(phone).presence && "tel:#{normalized_team_contact_phone(phone)}"
  end

  def team_contact_whatsapp_href(phone)
    normalized = normalized_team_contact_phone(phone)
    normalized.present? && "https://wa.me/#{normalized.delete_prefix('+')}"
  end

  private

  def normalized_team_contact_phone(phone)
    value = phone.to_s.strip
    return if value.blank?

    digits = value.gsub(/[^\d+]/, "")
    return "+#{digits.delete_prefix('00')}" if digits.start_with?("00")
    return digits if digits.start_with?("+")
    return "+#{digits}" if digits.start_with?("49")
    return "+49#{digits.delete_prefix('0')}" if digits.start_with?("0")

    "+49#{digits}"
  end
end
