# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module ConduitApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.autoload_paths += %W[#{config.root}/lib]

    # This also configures session_options for use below
    config.session_store :cookie_store, key: '_conduit_session'

    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use ActionDispatch::Flash
    config.middleware.use config.session_store, config.session_options

    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
