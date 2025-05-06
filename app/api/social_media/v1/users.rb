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
          # User.all
          { status: "ok" }
        end

        desc 'Get current user profile'
        get :me do
          authenticate!
          current_user_profile
        end

        desc 'Search users by username'
        params do
          requires :query, type: String, desc: 'Username search query'
          optional :page, type: Integer, desc: 'Page number', default: 1
          optional :per_page, type: Integer, desc: 'Number of results per page', default: 10
        end
        get "/search" do
          puts "Searching for username: #{params[:query]}"
          # { status: "ok" }
          # authenticate!
          search_by_username
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
        get ':id/followers/:page' do
          all_followers
        end

        desc 'Get user following'
        params do
          requires :id, type: Integer, desc: 'User ID'
          optional :page, type: Integer, desc: 'Page number', default: 1
          optional :per_page, type: Integer, desc: 'Number of results per page', default: 10
        end
        get ':id/followings' do
          all_followings
        end
      end
    end
  end
end