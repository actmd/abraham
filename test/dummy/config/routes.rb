# frozen_string_literal: true

Rails.application.routes.draw do
  get "dashboard/home"
  get "dashboard/other"
  get "dashboard/placement"
  get "dashboard/missing"
  get "dashboard/buttons"

  namespace :foobar do
    get "dashboard/home"
  end

  mount Abraham::Engine, at: 'abraham'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
