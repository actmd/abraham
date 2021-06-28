# frozen_string_literal: true

Abraham::Engine.routes.draw do
  resources :histories, only: :create
end
