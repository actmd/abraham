# frozen_string_literal: true

Rails.application.configure do
  tours = {}
  tours_root = Pathname.new(Rails.root.join('config', 'tours'))

  if Rails.root.join('config', 'tours').exist?
    Dir.glob(Rails.root.join('config', 'locales', 'tours', '**', '*.yml')).each do |yml|
      relative_filename = Pathname.new(yml).relative_path_from(tours_root)
      # `controller_path` is either "controller_name" or "module_name/controller_name"
      controller_path, filename = relative_filename.split
      file_parts = filename.to_s.split(".")
      action = file_parts[0]
      locale = file_parts[1]
      t = YAML.load_file(yml)
      tours["#{controller_path}.#{action}.#{locale}"] = t
    end
  end

  abraham_config = Rails.application.config_for :abraham
  config.abraham = ActiveSupport::OrderedOptions.new
  config.abraham.tour_options = abraham_config[:tour_options]
  config.abraham.tours = tours
end
