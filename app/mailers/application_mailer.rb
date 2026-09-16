class ApplicationMailer < ActionMailer::Base
  around_action :use_german_locale
  helper_method :recipient_name

  default(
    from: ENV.fetch("MAILER_FROM", "Lightcamp HQ <lightcamp@freikirche-hl.de>"),
    reply_to: ENV.fetch("MAILER_REPLY_TO", "lightcamp@freikirche-hl.de")
  )
  layout "mailer"

  private

  # Ältere Konten können noch keinen Vornamen enthalten. Die E-Mail-Adresse ist
  # deshalb ein zuverlässiger Fallback statt einer leeren Anrede.
  def recipient_name(user)
    user.first_name.presence || user.email
  end

  # Auch Systemmails ohne Anfragekontext, etwa Passwort-Resets, bleiben deutsch.
  def use_german_locale(&)
    I18n.with_locale(:de, &)
  end
end
