module SocialMedia
  module V1
    class Auth < Grape::API
      version 'v1', using: :path
      format :json
    
      helpers AuthHelper

      resource :auth do
        desc 'User registration'
        params do
          requires :username, type: String, desc: 'Username'
          requires :email, type: String, desc: 'Email address'
          requires :password, type: String, desc: 'Password'
          optional :bio, type: String, desc: 'User bio'
        end
        post :signup do
          signup
        end
        
        desc 'User login'
        params do
          requires :email, type: String, desc: 'Email address'
          requires :password, type: String, desc: 'Password'
        end
        post :login do
          login
        end
      end
    end
  end
end