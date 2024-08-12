# frozen_string_literal: true

require "test_helper"
require "rails/generators"
require "generators/abraham/install_generator"

# Test para generador de Abraham
class InstallGeneratorTest < Rails::Generators::TestCase
  tests Abraham::Generators::InstallGenerator
  destination File.expand_path("../tmp", __dir__)

  setup :prepare_destination

  should "generar migracion para crear la tabla abraham_histories" do
    begin
      run_generator
      assert_migration "db/migrate/create_abraham_histories"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  should "--skip-migration debe saltar la generacion de la migracion" do
    begin
      run_generator ["--skip-migration"]
      assert_no_migration "db/migrate/create_abraham_histories"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  should "generar el inicializador de abraham" do
    begin
      run_generator
      assert_file "config/initializers/abraham.rb"
      assert_file "config/abraham.yml"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  should "--skip-initializer debe saltar la generación del inicializador de abraham" do
    begin
      run_generator ["--skip-initializer"]
      assert_no_file "config/initializers/abraham.rb"
    ensure
      FileUtils.rm_rf destination_root
    end
  end
end
