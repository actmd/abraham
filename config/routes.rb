# frozen_string_literal: true
Rails.application.routes.draw do
  resources :abraham_histories, only: :create
end
