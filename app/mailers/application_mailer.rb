class ApplicationMailer < ActionMailer::Base
  default(
    from: ENV.fetch("MAILER_FROM", "Lightcamp HQ <lightcamp@freikirche-hl.de>"),
    reply_to: ENV.fetch("MAILER_REPLY_TO", "lightcamp@freikirche-hl.de")
  )
  layout "mailer"
end
