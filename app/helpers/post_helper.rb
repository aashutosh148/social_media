module PostHelper 
  def feed 
    posts = current_user.feed_posts.includes(:user).limit(20)
    posts.map do |post|
      post.as_json(include: { 
        user: { only: %i[id username avatar_url] } 
      })
    end
  end

  def new_post
    post = current_user.posts.new(content: params[:content])
          
    post.image.attach(params[:image]) if params[:image]
          
    if post.save
      post.as_json(include: { 
        user: { only: %i[id username avatar_url] } 
      })
    else
      error!({ errors: post.errors.full_messages }, 422)
    end
  end

  def post_by_id
    post = Post.includes(:user).find(params[:id])
    post.as_json(include: { 
      user: { only: %i[id username avatar_url] } 
    })
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'Post not found' }, 404)
  end

  def remove_post
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