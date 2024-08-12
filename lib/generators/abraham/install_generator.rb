# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module Abraham
  module Generators
    # Instalador de Abraham
    class InstallGenerator < ActiveRecord::Generators::Base
      argument :name, type: :string, default: "random_name"

      class_option :'skip-migration', type: :boolean, desc: "Don't generate a migration for the histories table"
      class_option :'skip-initializer', type: :boolean, desc: "Don't generate an initializer"
      class_option :'skip-config', type: :boolean, desc: "Don't generate a config file"

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      # Copies the migration template to db/migrate.
      def copy_files
        return if options["skip-migration"]

        migration_template "migration.rb", "db/migrate/create_abraham_histories.rb"
      end

      def create_initializer
        return if options["skip-initializer"]

        copy_file "initializer.rb", "config/initializers/abraham.rb"
      end

      def create_config
        return if options["skip-config"]

        copy_file "abraham.yml", "config/abraham.yml"
      end
    end
  end
end
