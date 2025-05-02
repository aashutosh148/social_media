module SocialMedia
  module Helpers
    def current_user
      @current_user ||= User.find(@current_user_id) if @current_user_id
    end
    
    def authenticate!
      error!('Unauthorized', 401) unless current_user
    end

    def is_admin?
      error!('Forbidden', 403) unless current_user && (current_user.id == 5)
      puts current_user
    end
    
    def authorize!(owner)
      error!('Forbidden', 403) unless current_user && (current_user.id == owner.id)
    end
  end
end