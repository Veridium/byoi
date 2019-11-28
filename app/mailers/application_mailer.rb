class ApplicationMailer < ActionMailer::Base
  default from: ENV["FROM_FOR_EMAIL"]
  layout 'mailer'
end
