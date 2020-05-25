class ApplicationMailer < ActionMailer::Base
  default from: Settings.DEFAULT_EMAIL
  layout "mailer"
end
