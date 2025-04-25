module SocialMedia
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :users do
        desc 'Get current user profile'
        get :me do
          authenticate!
          current_user.as_json(except: :password_digest)
        end
        
        desc 'Get user profile by ID'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id' do
          user = User.find(params[:id])
          user.as_json(except: :password_digest)
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'User not found' }, 404)
        end
        
        desc 'Update current user profile'
        params do
          optional :username, type: String, desc: 'Username'
          optional :bio, type: String, desc: 'User bio'
          optional :avatar, type: File, desc: 'Profile picture'
        end
        put :me do
          authenticate!
          
          update_params = {}
          update_params[:username] = params[:username] if params[:username]
          update_params[:bio] = params[:bio] if params[:bio]
          
          if params[:avatar]
            current_user.avatar.attach(params[:avatar])
          end
          
          if current_user.update(update_params)
            current_user.as_json(except: :password_digest)
          else
            error!({ errors: current_user.errors.full_messages }, 422)
          end
        end
        
        desc 'Follow a user'
        params do
          requires :id, type: Integer, desc: 'User ID to follow'
        end
        post ':id/follow' do
          authenticate!
          user_to_follow = User.find(params[:id])
          
          if current_user.id == user_to_follow.id
            error!({ error: 'Cannot follow yourself' }, 422)
          end
          
          follow = Follow.find_or_initialize_by(
            follower: current_user,
            following: user_to_follow
          )
          
          if follow.new_record? && follow.save
            { status: 'success', followed: true }
          else
            { status: 'success', followed: true, message: 'Already following' }
          end
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'User not found' }, 404)
        end
        
        desc 'Unfollow a user'
        params do
          requires :id, type: Integer, desc: 'User ID to unfollow'
        end
        delete ':id/follow' do
          authenticate!
          follow = Follow.find_by(
            follower_id: current_user.id,
            following_id: params[:id]
          )
          
          if follow && follow.destroy
            { status: 'success', followed: false }
          else
            error!({ error: 'Not following this user' }, 404)
          end
        end
        
        desc 'Get user followers'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id/followers' do
          user = User.find(params[:id])
          user.followers.select(:id, :username, :bio, :avatar_url)
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'User not found' }, 404)
        end
        
        desc 'Get user following'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id/following' do
          user = User.find(params[:id])
          user.following.select(:id, :username, :bio, :avatar_url)
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'User not found' }, 404)
        end
      end
    end
  end
end