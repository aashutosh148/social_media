require 'bcrypt'
require 'faker'

puts "Seeding started at #{Time.now}"

# ---- USERS ----
digest = BCrypt::Password.create('password')
users = []

puts "Creating users..."
100_000.times do |i|
  users << {
    username: "user#{i+1}",
    email: "user#{i+1}@example.com",
    password_digest: digest,
    bio: "Bio for user #{i+1}",
    created_at: Time.now,
    updated_at: Time.now
  }

  if users.size == 2000
    User.insert_all(users)
    puts "Inserted #{i+1} users"
    users = []
  end
end
User.insert_all(users) unless users.empty?
puts "Finished inserting users"

user_ids = User.pluck(:id)

# ---- FOLLOWS ----
puts "Creating follows..."
follows = []
user_ids.each_with_index do |user_id, i|
  sample_ids = user_ids.sample(3) - [user_id]
  sample_ids.each do |follow_id|
    follows << {
      follower_id: user_id,
      following_id: follow_id,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  if follows.size >= 2000
    Follow.insert_all(follows)
    puts "Inserted follows for #{i+1} users"
    follows = []
  end
end
Follow.insert_all(follows) unless follows.empty?
puts "Finished inserting follows"

# ---- POSTS ----
puts "Creating posts..."
posts = []
user_ids.each_with_index do |user_id, i|
  2.times do
    posts << {
      user_id: user_id,
      content: Faker::Lorem.paragraph,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  if posts.size >= 2000
    Post.insert_all(posts)
    puts "Inserted posts for #{i+1} users"
    posts = []
  end
end
Post.insert_all(posts) unless posts.empty?
puts "Finished inserting posts"

post_ids = Post.pluck(:id)

# ---- COMMENTS & LIKES ----
puts "Creating comments and likes..."
comments = []
likes = []
user_ids.each_with_index do |user_id, i|
  post_ids.sample(5).each do |post_id|
    comments << {
      user_id: user_id,
      post_id: post_id,
      content: Faker::Lorem.sentence,
      created_at: Time.now,
      updated_at: Time.now
    }

    likes << {
      user_id: user_id,
      post_id: post_id,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  if comments.size >= 2000
    Comment.insert_all(comments)
    Like.insert_all(likes)
    puts "Inserted comments and likes for #{i+1} users"
    comments = []
    likes = []
  end
end
Comment.insert_all(comments) unless comments.empty?
Like.insert_all(likes) unless likes.empty?

puts "Seeding completed successfully at #{Time.now}!"
