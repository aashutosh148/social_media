module CacheHelper
  def set_cache(key, value)
    REDIS_CLIENT.set(key, value, ex: 15.seconds)
  end

  def get_cache(key)
    cached_value = REDIS_CLIENT.get(key)
    JSON.parse(cached_value) if cached_value
    cached_value
  end
  
end

# get :ping do
#   data = { test: "hello" }
  
#   cached_user = REDIS_CLIENT.get("test_key")
#   REDIS_CLIENT.set("test_key", JSON.dump(data), ex: 60)
#   # byebug
#   parsed_user = JSON.parse(cached_user) if cached_user
#   # puts "THERE YOU GO SON #{parsed_user['test']}" # Access using string key
#   proper_cached_user = parsed_user

#   { status: "ok #{proper_cached_user&.[]('test')}", time: Time.now } # Access using string key
# end