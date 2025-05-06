source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.10'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.0'    # Testing framework
  gem 'factory_bot_rails'        # Test data factories
  gem 'faker'                    # Fake data generation
  gem 'pry-rails'                # Better console
end

group :development do
  gem 'annotate'                 # Model annotations
  gem 'bullet'                   # N+1 query detection
  gem 'listen', '~> 3.0.5'
  gem 'ruby-lsp'
  gem 'rubocop'
  gem 'byebug'
end

group :test do
  gem "database_cleaner-active_record"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# API and Auth
gem 'bcrypt', '~> 3.1.7'       # Password hashing
gem 'grape', '~> 1.7'          # API framework
gem 'grape-entity', '~> 1.0'   # API presenters
gem 'jwt', '~> 2.7'            # JSON Web Tokens
gem 'rack-cors'                # Cross-Origin Resource Sharing

# Background Jobs
gem 'redis', '~> 4.8'          # Redis client for Sidekiq and caching
gem 'sidekiq', '~> 7.1'        # Background job processing

# File Upload
gem "image_processing", "~> 1.2" # For ActiveStorage variants

#API docs
gem 'grape-swagger'

gem 'grape_logging'

gem 'colorize'
gem "grape_on_rails_routes", "~> 0.3.2"

gem "will_paginate", "~> 4.0"


gem "redis-rails", "~> 5.0"
