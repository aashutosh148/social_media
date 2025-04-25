# config/initializers/sidekiq_web.rb
require 'sidekiq/web'

# ✅ Add only the required middleware for sessions & cookies
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_sidekiq_session'
