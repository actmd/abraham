# frozen_string_literal: true

source "http://rubygems.org"
source "http://rails-assets.org"

# Declare your gem's dependencies in abraham.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# These rails-assets dependencies need to be added to the developer's Gemfile
# since there's no way to specify a source in the gemspec.
source "http://rails-assets.org" do
  gem "rails-assets-js-cookie", "~> 2.1"
  gem "rails-assets-shepherd.js", "~> 1.8"
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

# Avoid the 'multiple sources' confusion
gem "rails-assets-tether", source: "http://rails-assets.org/"
