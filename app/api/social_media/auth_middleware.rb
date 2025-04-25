module SocialMedia
  class AuthMiddleware < Grape::Middleware::Base
    def before
      return if public_endpoint?
      
      token = auth_header
      return unless token
      
      payload = AuthService.decode(token)
      env['api.user_id'] = payload['user_id'] if payload
    end
    
    private
    
    def auth_header
      authorization = env['HTTP_AUTHORIZATION']
      return unless authorization
      
      authorization.split(' ').last
    end
    
    def public_endpoint?
      path = env['PATH_INFO']
      method = env['REQUEST_METHOD']
      
      # Define public endpoints
      (path.include?('/api/v1/auth/') && !path.include?('/logout')) ||
        (path.include?('/api/v1/ping'))
    end
  end
end