module SocialMedia
  module V1
    class Base < Grape::API
      version 'v1', using: :path
      format :json
      
      # Use auth middleware
      use SocialMedia::AuthMiddleware
      
      helpers SocialMedia::Helpers
      
      before do
        @current_user_id = env['api.user_id']
      end
      
      # Mount all endpoints
      mount SocialMedia::V1::Auth
      mount SocialMedia::V1::Users
      mount SocialMedia::V1::Posts
      mount SocialMedia::V1::Comments
      mount SocialMedia::V1::Likes
      mount SocialMedia::V1::Notifications
      
      # Health check endpoint
      get :ping do
        { status: 'ok', time: Time.now }
      end

      add_swagger_documentation(
        api_version: 'v1',
        hide_format: true,
        hide_documentation_path: false,
        mount_path: '/swagger_doc',
        info: {
          title: 'SocialMedia API',
          description: 'API documentation for SocialMedia platform'
        }
      )
    end
  end
end