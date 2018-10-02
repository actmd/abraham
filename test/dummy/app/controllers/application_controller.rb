# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    OpenStruct.new(id: Random.rand(1..99_999))
  end
end
