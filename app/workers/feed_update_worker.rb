class FeedUpdateWorker
  include Sidekiq::Worker
  
  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post
    
    # Cache key for post in Redis
    cache_key = "post:#{post.id}"
    post_json = post.as_json(include: { 
      user: { only: [:id, :username, :avatar_url] } 
    })
    
    # Store post in Redis cache (expires in 24 hours)
    Redis.current.setex(cache_key, 24.hours.to_i, post_json.to_json)
    
    # Get followers who should see this post
    followers = post.user.followers
    
    # For each follower, add this post to their feed set in Redis
    followers.each do |follower|
      feed_key = "user:#{follower.id}:feed"
      # Add post_id to sorted set with score as timestamp
      Redis.current.zadd(feed_key, post.created_at.to_i, post.id)
      # Trim the feed to keep only the most recent 100 posts
      Redis.current.zremrangebyrank(feed_key, 0, -101)
    end
  end
end