$redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0")
REDIS_CLIENT = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0", timeout: 1)