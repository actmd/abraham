# frozen_string_literal: true

require "test_helper"
require "rails/generators"
require "generators/abraham/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Abraham::Generators::InstallGenerator
  destination File.expand_path("../tmp", __dir__)

  setup :prepare_destination

  test "should generate a migration" do
    begin
      run_generator
      assert_migration "db/migrate/create_abraham_histories"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  test "should skip the migration when told to do so" do
    begin
      run_generator ["--skip-migration"]
      assert_no_migration "db/migrate/create_abraham_histories"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  test "should generate an initializer" do
    begin
      run_generator
      assert_file "config/initializers/abraham.rb"
      assert_file "config/abraham.yml"
    ensure
      FileUtils.rm_rf destination_root
    end
  end

  test "should skip the initializer when told to do so" do
    begin
      run_generator ["--skip-initializer"]
      assert_no_file "config/initializers/abraham.rb"
    ensure
      FileUtils.rm_rf destination_root
    end
  end
end
