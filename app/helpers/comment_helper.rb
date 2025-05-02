module CommentHelper
  def add_comment
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
        user: { only: %i[id username avatar_url] } 
      })
    else
      error!({ errors: comment.errors.full_messages }, 422)
    end
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Post not found' }, 404)
  end

  def comments_of_post
    post = Post.find(params[:post_id])
    comments = post.comments.includes(:user).order(created_at: :desc)
      
    comments.map do |comment|
      comment.as_json(include: { 
        user: { only: %i[id username avatar_url] } 
      })
    end
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Post not found' }, 404)
  end

  def remove_comment
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