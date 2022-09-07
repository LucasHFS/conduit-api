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

    config.api_only = true
  end
end
