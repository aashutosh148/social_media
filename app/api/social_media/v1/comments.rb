module SocialMedia
  module V1
    class Comments < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :posts do
        route_param :post_id do
          desc 'Get comments for a post'
          get :comments do
            post = Post.find(params[:post_id])
            comments = post.comments.includes(:user).order(created_at: :desc)
              
            comments.map do |comment|
              comment.as_json(include: { 
                user: { only: [:id, :username, :avatar_url] } 
              })
            end
          rescue ActiveRecord::RecordNotFound
            error!({ error: 'Post not found' }, 404)
          end
          
          desc 'Add a comment to a post'
          params do
            requires :content, type: String, desc: 'Comment content'
          end
          post :comments do
            authenticate!
            
            post = Post.find(params[:post_id])
            comment = post.comments.new(
              user: current_user,
              content: params[:content]
            )
            
            if comment.save
              # Increment comments count
              post.increment!(:comments_count)
              
              # Create notification for post owner
              if post.user_id != current_user.id
                Notification.create(
                  recipient: post.user,
                  actor: current_user,
                  action: 'commented',
                  notifiable: comment
                )
              end
              
              comment.as_json(include: { 
                user: { only: [:id, :username, :avatar_url] } 
              })
            else
              error!({ errors: comment.errors.full_messages }, 422)
            end
          rescue ActiveRecord::RecordNotFound
            error!({ error: 'Post not found' }, 404)
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
          
          comment = Comment.find(params[:id])
          authorize!(comment.user)
          
          post = comment.post
          
          if comment.destroy
            # Decrement comments count
            post.decrement!(:comments_count)
            { status: 'success' }
          else
            error!({ error: 'Could not delete comment' }, 500)
          end
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'Comment not found' }, 404)
        end
      end
    end
  end
end