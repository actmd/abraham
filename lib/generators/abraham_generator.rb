require 'rails/generators'
require "rails/generators/active_record"

class AbrahamGenerator < ActiveRecord::Generators::Base
  argument :name, type: :string, default: 'random_name'

  class_option :'skip-migration', :type => :boolean, :desc => "Don't generate a migration for the histories table"
  class_option :'skip-initializer', :type => :boolean, :desc => "Don't generate an initializer"

  source_root File.expand_path('../../abraham', __FILE__)

  # Copies the migration template to db/migrate.
  def copy_files
    return if options['skip-migration']
    migration_template 'migration.rb', 'db/migrate/create_abraham_histories.rb'
  end

  def create_initializer
    return if options['skip-initializer']
    copy_file 'initializer.rb', 'config/initializers/abraham.rb'
  end
end
