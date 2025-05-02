module SocialMedia
  module V1
    class Likes < Grape::API
      version 'v1', using: :path
      format :json
      
      helpers LikeHelper

      resource :posts do
        route_param :post_id do
          desc 'Like a post'
          post :like do
            authenticate!
            like
          end
          
          desc 'Unlike a post'
          delete :like do
            authenticate!
            unlike
          end
        end
      end
    end
  end
end 