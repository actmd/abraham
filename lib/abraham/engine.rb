# frozen_string_literal: true

require "rubygems"

module Abraham
  class Engine < ::Rails::Engine
    require "rails-assets-shepherd.js"
    require "jquery-rails"
    require "rails-assets-js-cookie"
  end
end
