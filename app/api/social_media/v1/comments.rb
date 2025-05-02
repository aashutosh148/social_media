module SocialMedia
  module V1
    class Comments < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :posts do
        route_param :post_id do
          desc 'Get comments for a post'
          get :comments do
            comments_of_post
          end
          
          desc 'Add a comment to a post'
          params do
            requires :content, type: String, desc: 'Comment content'
          end
          post :comments do
            authenticate!
            
            add_comment
          end
        end
      end
      
      resource :comments do
        desc 'Delete a comment'
        params do
          requires :id, type: Integer, desc: 'Comment ID'
        end
        delete ':id' do
          authenticate!
          
          remove_comment
        end
      end
    end
  end
end