module LikeHelper
  def like 
    post = Post.find(params[:post_id])
    like = Like.find_or_initialize_by(
      user: current_user,
      post: post
    )
            
    if like.new_record?
      if like.save
        post.increment!(:likes_count)
        
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

  def unlike
    post = Post.find(params[:post_id])
    like = Like.find_by(
      user: current_user,
      post: post
    )
            
    if like&.destroy
      post.decrement!(:likes_count)
      { status: 'success', liked: false }
    else
      error!({ error: 'Not liked' }, 404)
    end
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Post not found' }, 404)
  end
end