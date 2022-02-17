# frozen_string_literal: true

module Abraham
  class Engine < ::Rails::Engine
    isolate_namespace Abraham

    ActiveSupport.on_load(:action_controller_base) do
      helper AbrahamHelper
    end
  end
end
