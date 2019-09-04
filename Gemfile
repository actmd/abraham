# frozen_string_literal: true
source 'http://rubygems.org'

# Set the Rails version. We have this switch so that we can test multiple
# versions for Rails on Travis CI.
rails_version = ENV['RAILS_VERSION'] || 'default'
rails = case rails_version
        when 'master'
          {github: 'rails/rails'}
        when 'default'
          '~> 5.1'
        else
        '~> #{rails_version}'
        end
gem 'rails', rails

# Declare your gem's dependencies in abraham.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'mocha'
end
