# frozen_string_literal: true
Rails.application.configure do
  tours = {}

  if Rails.root.join('config/tours').exist?
    Dir[Rails.root.join('config/tours/*/')].each do |dir|
      Dir[dir + '*.yml'].each do |yml|
        path_parts = yml.split(File::SEPARATOR)
        controller = path_parts[path_parts.size - 2]
        file_parts = path_parts[path_parts.size - 1].split('.')
        action = file_parts[0]
        locale = file_parts[1]
        t = YAML.load_file(yml)
        tours["#{controller}.#{action}.#{locale}"] = t
      end
    end
  end

  abraham_config = Rails.application.config_for :abraham
  config.abraham = ActiveSupport::OrderedOptions.new
  config.abraham.default_theme = abraham_config[:default_theme]
  config.abraham.tours = tours
end
