require 'sidekiq/web'
require 'grape'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"


Rails.application.routes.draw do
  # Mount Sidekiq web UI
  
  mount Sidekiq::Web => '/sidekiq'
  
  # Mount Grape API
  mount SocialMedia::Api => '/'

  # Health check endpoint
  get '/alive', to: proc { [200, {}, ['OK']] }
end