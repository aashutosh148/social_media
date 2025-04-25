module SocialMedia
  module V1
    class Auth < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :auth do
        desc 'User registration'
        params do
          requires :username, type: String, desc: 'Username'
          requires :email, type: String, desc: 'Email address'
          requires :password, type: String, desc: 'Password'
          optional :bio, type: String, desc: 'User bio'
        end
        post :signup do
          user = User.new(
            username: params[:username],
            email: params[:email],
            password: params[:password],
            bio: params[:bio]
          )
          if user.save
            token = AuthService.encode(user_id: user.id)
            { token: token, user: user.as_json(except: :password_digest) }
          else
            error!({ errors: user.errors.full_messages }, 422)
          end
        end
        
        desc 'User login'
        params do
          requires :email, type: String, desc: 'Email address'
          requires :password, type: String, desc: 'Password'
        end
        post :login do
          user = User.find_by(email: params[:email])
          
          if user && user.authenticate(params[:password])
            token = AuthService.encode(user_id: user.id)
            { token: token, user: user.as_json(except: :password_digest) }
          else
            error!({ error: 'Invalid email or password' }, 401)
          end
        end
      end
    end
  end
end