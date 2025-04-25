module SocialMedia
  module V1
    class Posts < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :posts do
        desc 'Get personalized feed'
        get :feed do
          authenticate!
          posts = current_user.feed_posts.includes(:user).limit(20)
          posts.map do |post|
            post.as_json(include: { 
              user: { only: [:id, :username, :avatar_url] } 
            })
          end
        end
        
        desc 'Create a new post'
        params do
          requires :content, type: String, desc: 'Post content'
          optional :image, type: File, desc: 'Image attachment'
        end
        post do
          authenticate!
          
          post = current_user.posts.new(content: params[:content])
          
          if params[:image]
            post.image.attach(params[:image])
          end
          
          if post.save
            post.as_json(include: { 
              user: { only: [:id, :username, :avatar_url] } 
            })
          else
            error!({ errors: post.errors.full_messages }, 422)
          end
        end
        
        desc 'Get a specific post'
        params do
          requires :id, type: Integer, desc: 'Post ID'
        end
        get ':id' do
          post = Post.includes(:user).find(params[:id])
          post.as_json(include: { 
            user: { only: [:id, :username, :avatar_url] } 
          })
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'Post not found' }, 404)
        end
        
        desc 'Delete a post'
        params do
          requires :id, type: Integer, desc: 'Post ID'
        end
        delete ':id' do
          authenticate!
          post = Post.find(params[:id])
          
          authorize!(post.user)
          
          if post.destroy
            { status: 'success' }
          else
            error!({ error: 'Could not delete post' }, 500)
          end
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'Post not found' }, 404)
        end
      end
    end
  end
end