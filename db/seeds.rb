# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create test users
5.times do |i|
  User.create!(
    username: "user#{i+1}",
    email: "user#{i+1}@example.com",
    password: "password",
    bio: "Bio for user #{i+1}"
  )
end

# Create some follows
users = User.all
users.each do |user|
  other_users = users - [user]
  other_users.sample(2).each do |other_user|
    Follow.create!(follower: user, following: other_user)
  end
end

# Create some posts
users.each do |user|
  3.times do |i|
    Post.create!(
      user: user,
      content: "Post #{i+1} by #{user.username}: #{Faker::Lorem.paragraph}"
    )
  end
end

# Add some comments and likes
posts = Post.all
users.each do |user|
  posts.sample(5).each do |post|
    # Add comments
    Comment.create!(
      user: user,
      post: post,
      content: Faker::Lorem.sentence
    )
    
    # Add likes
    Like.create!(
      user: user,
      post: post
    )
  end
end

puts "Seed data created successfully!"