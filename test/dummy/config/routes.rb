# frozen_string_literal: true

Rails.application.routes.draw do
  get "dashboard/home"
  get "dashboard/other"
  get "dashboard/missing"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
