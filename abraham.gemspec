# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'abraham/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'abraham'
  s.version     = Abraham::VERSION
  s.authors     = ['Jonathan Abbett']
  s.email       = ['jonathan@act.md']
  s.homepage    = 'https://github.com/actmd/abraham'
  s.summary     = 'Trackable application tours for Rails with i18n support, based on Shepherd.js.'
  s.description = 'Trackable application tours for Rails with i18n support, based on Shepherd.js.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0', '>= 5.0.0.1'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'rails-assets-shepherd.js', '~> 1.8'
  s.add_dependency 'rails-assets-js-cookie', '~> 2.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop'
end
