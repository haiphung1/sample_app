require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 6.0

    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    I18n.available_locales = [:vi, :en]
    I18n.default_locale = :vi

    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
