# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
end
