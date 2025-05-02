module SocialMedia
  module V1
    class Posts < Grape::API
      version 'v1', using: :path
      format :json

      helpers PostHelper
      
      resource :posts do
        desc 'Get personalized feed'
        get :feed do
          authenticate!
          feed
        end
        
        desc 'Create a new post'
        params do
          requires :content, type: String, desc: 'Post content'
          optional :image, type: File, desc: 'Image attachment'
        end
        post do
          authenticate!
          new_post
        end
        
        desc 'Get a specific post'
        params do
          requires :id, type: Integer, desc: 'Post ID'
        end
        get ':id' do
          post_by_id
        end
        
        desc 'Delete a post'
        params do
          requires :id, type: Integer, desc: 'Post ID'
        end
        delete ':id' do
          authenticate!
          remove_post
        end
      end
    end
  end
end