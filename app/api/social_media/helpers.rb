module SocialMedia
  module Helpers
    include CacheHelper

    def current_user
      return @current_user if defined?(@current_user)
    
      key = "auth/#{@current_user_id}"
      cached = get_cache(key)
      if cached
        Rails.logger.info "Cache hit for current_user #{@current_user_id}"
        @current_user = User.new(JSON.parse(cached))
      else
        @current_user = User.find(@current_user_id)
        set_cache(key, JSON.dump(@current_user.as_json))
      end
      @current_user
    end
    
    def authenticate!
      error!('Unauthorized', 401) unless current_user
    end

    def admin?
      error!('Forbidden', 403) unless current_user && (current_user.id == 5)
      puts current_user
    end
    
    def authorize!(owner)
      error!('Forbidden', 403) unless current_user && (current_user.id == owner.id)
    end
  end
end