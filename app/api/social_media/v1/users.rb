module SocialMedia
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json
      helpers SocialMedia::Helpers
      helpers UserHelper

      desc 'get all users'
      resource :users do
        get "/all" do
          authenticate!
          User.all
        end

        desc 'Get current user profile'
        get :me do
          authenticate!
          current_user_profile
        end
        
        desc 'Get user profile by ID'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id' do
          authenticate!
          by_id
        end
        
        desc 'Update current user profile'
        params do
          optional :username, type: String, desc: 'Username'
          optional :bio, type: String, desc: 'User bio'
          optional :avatar, type: File, desc: 'Profile picture'
        end
        put :me do
          authenticate!
          update_current
        end
        
        desc 'Follow a user'
        params do
          requires :id, type: Integer, desc: 'User ID to follow'
        end
        post ':id/follow' do
          authenticate!
          follow_user
        end
        
        desc 'Unfollow a user'
        params do
          requires :id, type: Integer, desc: 'User ID to unfollow'
        end
        delete ':id/follow' do
          authenticate!
          unfollow_user 
        end
        
        desc 'Get user followers'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id/followers' do
          all_followers
        end

        desc 'Get user following'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        get ':id/following' do
          all_followings
        end
      end
    end
  end
end