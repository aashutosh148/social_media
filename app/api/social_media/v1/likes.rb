module SocialMedia
  module V1
    class Likes < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :posts do
        route_param :post_id do
          desc 'Like a post'
          post :like do
            authenticate!
            
            post = Post.find(params[:post_id])
            like = Like.find_or_initialize_by(
              user: current_user,
              post: post
            )
            
            if like.new_record?
              if like.save
                # Increment likes count
                post.increment!(:likes_count)
                
                # Create notification for post owner
                if post.user_id != current_user.id
                  Notification.create(
                    recipient: post.user,
                    actor: current_user,
                    action: 'liked',
                    notifiable: post
                  )
                end
                
                { status: 'success', liked: true }
              else
                error!({ errors: like.errors.full_messages }, 422)
              end
            else
              { status: 'success', liked: true, message: 'Already liked' }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ error: 'Post not found' }, 404)
          end
          
          desc 'Unlike a post'
          delete :like do
            authenticate!
            
            post = Post.find(params[:post_id])
            like = Like.find_by(
              user: current_user,
              post: post
            )
            
            if like && like.destroy
              # Decrement likes count
              post.decrement!(:likes_count)
              { status: 'success', liked: false }
            else
              error!({ error: 'Not liked' }, 404)
            end
          rescue ActiveRecord::RecordNotFound
            error!({ error: 'Post not found' }, 404)
          end
        end
      end
    end
  end
end 