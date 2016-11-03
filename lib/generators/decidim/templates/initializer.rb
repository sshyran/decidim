# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "My Application Name"
  config.mailer_sender    = "change-me@domain.org"
  config.authorization_handlers = [ExampleAuthorizationHandler]
end
