# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path('../dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../dummy/db/migrate', __FILE__)]
require 'rails/test_help'
require 'mocha/minitest'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
