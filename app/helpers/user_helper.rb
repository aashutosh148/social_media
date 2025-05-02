module UserHelper
  def current_user
    @current_user ||= User.find(@current_user_id) if @current_user_id
  end
  
  def authenticate!
    error!('Unauthorized', 401) unless current_user
  end

  def is_admin?
    error!('Forbidden', 403) unless current_user && (current_user.id == 5)
    puts current_user
  end
  
  def authorize!(owner)
    error!('Forbidden', 403) unless current_user && (current_user.id == owner.id)
  end

  def current_user_profile
    current_user.as_json(except: :password_digest)
  end

  def by_id
    user = User.find(params[:id])
    user.as_json(except: :password_digest)
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'User not found' }, 404)
  end

  def update_current
    update_params = {}
    update_params[:username] = params[:username] if params[:username]
    update_params[:bio] = params[:bio] if params[:bio]
          
    @current_user.avatar.attach(params[:avatar]) if params[:avatar]
          
    if current_user.update(update_params)
      current_user.as_json(except: :password_digest)
    else
      error!({ errors: current_user.errors.full_messages }, 422)
    end
  end

  def follow_user
    user_to_follow = User.find(params[:id])
          
    error!({ error: 'Cannot follow yourself' }, 422) if current_user.id == user_to_follow.id
          
    follow = Follow.find_or_initialize_by(
      follower: current_user,
      following: user_to_follow
    )
          
    if follow.new_record? && follow.save
      { status: 'success', followed: true }
    else
      error!({ error: 'Cannot follow ' }, 422)
    end
  rescue ActiveRecord::RecordNotFound
    error!({ error: 'User not found' }, 404)
  end

  def unfollow_user
    follow = Follow.find_by(
      follower_id: current_user.id,
      following_id: params[:id]
    )
          
    if follow&.destroy
      { status: 'success', followed: false }
    else
      error!({ error: 'Not following this user' }, 404)
    end
  end

  def all_followers
    user = User.find_by(id: params[:id])
    if user
      followers = user.followers.select(:id, :username, :bio, :avatar_url)
      present followers
    else
      error!({ error: 'User not found' }, 404)
    end
  end

  def all_followings
    user = User.find_by(id: params[:id])
    if user
      following = user.following.select(:id, :username, :bio, :avatar_url)
      present following
    else
      error!({ error: 'User not found' }, 404)
    end
  end
end