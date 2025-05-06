module UserHelper # rubocop:disable Metrics/ModuleLength
  include CacheHelper

  def current_user
    return @current_user if defined?(@current_user)
    
    key = "auth/#{@current_user_id}"
    cached = get_cache(key)
    if cached
      Rails.logger.info "Cache hit for current_user #{@current_user_id}"
      @current_user = User.new(JSON.parse(cached))
    else
      @current_user = User.find(@current_user_id)
      set_cache(key, JSON.dump(@current_user.as_json))
    end
    @current_user
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
    key = "users/#{params[:id]}"
    cached_user = get_cache(key)
    if cached_user
      puts "Cache hit for user #{params[:id]}"
      data = JSON.parse(cached_user)
      @current_user = User.new(data) 
      return data
    end
  
    user = User.find(params[:id])
    data = UserEntity.represent(user)
    set_cache(key, JSON.dump(data))
    @current_user = user
    data
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
    is_new_follow = follow.new_record?

    if is_new_follow && follow.save
      
      SendNewFollowerEmailJob.set(wait: 10.seconds).perform_later(current_user.id, user_to_follow.id)

      { status: 'success', followed: true }
    elsif !is_new_follow
      error!({ error: 'Already following this user' }, 422) 
    else
      error!({ error: 'Cannot follow user', details: follow.errors.full_messages }, 422)
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
      per_page = (params[:per_page] || 10).to_i
      page = (params[:page] || 1).to_i
  
      followers = user.followers.select(:id, :username).paginate(page: page, per_page: per_page)
      present({
        followers: followers,
        meta: {
          total_entries: following.total_entries,
          total_pages: following.total_pages,
          current_page: following.current_page,
          per_page: per_page
        }
      })
    else
      error!({ error: 'User not found' }, 404)
    end
  end

  def all_followings
    user = User.find_by(id: params[:id])
    if user
      per_page = (params[:per_page] || 10).to_i
      page = (params[:page] || 1).to_i
  
      following = user.following.select(:id, :username).paginate(page: page, per_page: per_page)
  
      present({
        followings: following,
        meta: {
          total_entries: following.total_entries,
          total_pages: following.total_pages,
          current_page: following.current_page,
          per_page: per_page
        }
      })
    else
      error!({ error: 'User not found' }, 404)
    end
  end

  def search_by_username # rubocop:disable Metrics/AbcSize
    # authenticate!

    query = params[:query].to_s.strip
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    error!({ error: 'Search query must be at least 2 characters' }, 400) if query.length < 2

    cache_key = "users/search/#{query}/page/#{page}/per_page/#{per_page}"
    cached_results = get_cache(cache_key)

    if cached_results
      Rails.logger.info "Cache hit for username search: #{query}"
      return JSON.parse(cached_results)
    end

    users = User.where("username ILIKE ?", "%#{query}%").select(:id, :username, :created_at).paginate(page: page, per_page: per_page)

    results = {
      users: users.map(&:as_json), # Map each user object to its JSON representation
      data: {
        total_entries: users.total_entries,
        total_pages: users.total_pages,
        current_page: users.current_page,
        per_page: per_page,
        query: query
      }
    }

    REDIS_CLIENT.set(cache_key, JSON.dump(results), ex: 15.seconds)
    results
  end
end