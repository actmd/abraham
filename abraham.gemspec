# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "abraham/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "abraham"
  s.version     = Abraham::VERSION
  s.authors     = ["Jonathan Abbett"]
  s.email       = ["jonathan@act.md"]
  s.homepage    = "https://github.com/actmd/abraham"
  s.summary     = "Trackable application tours for Rails with i18n support, based on Shepherd.js."
  s.description = "Trackable application tours for Rails with i18n support, based on Shepherd.js."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency 'sassc-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'web-console'
  s.metadata['rubygems_mfa_required'] = 'true'
end
