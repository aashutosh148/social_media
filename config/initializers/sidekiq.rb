redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, network_timeout: 5 }
  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=#{Sidekiq.options[:concurrency] + 2}"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, network_timeout: 5 }
end
