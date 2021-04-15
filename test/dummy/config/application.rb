# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "abraham"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # This configuration is no longer necessary with Rails 6.1+
    unless Rails::VERSION::MAJOR >= 6 && Rails::VERSION::MINOR >= 1
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end
  end
end
