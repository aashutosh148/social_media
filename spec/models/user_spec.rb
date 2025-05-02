# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without a username" do
      user.username = nil
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate username" do
      existing_user = create(:user, username: "johndoe")
      user.username = "johndoe"
      expect(user).to_not be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is invalid with an invalid email format" do
      user.email = "invalid_email"
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate email" do
      existing_user = create(:user, email: "test@example.com")
      user.email = "test@example.com"
      expect(user).to_not be_valid
    end

    it "is invalid with a password shorter than 6 characters" do
      user.password = "short"
      expect(user).to_not be_valid
    end
  end

  # Associations
  describe "associations" do
    it "has many posts" do
      should have_many(:posts).dependent(:destroy)
    end

    it "has many comments" do
      should have_many(:comments).dependent(:destroy)
    end

    it "has many likes" do
      should have_many(:likes).dependent(:destroy)
    end

    it "has many followers" do
      should have_many(:followers).through(:follower_relationships)
    end

    it "has many following" do
      should have_many(:following).through(:following_relationships)
    end

    it "has many received notifications" do
      should have_many(:received_notifications).dependent(:destroy)
    end
  end

  # Methods
  describe "#feed_posts" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:unfollowed_user) { create(:user) }

    before do
      create(:follow, follower: user, following: followed_user)
      create(:post, user: user)
      create(:post, user: followed_user)
      create(:post, user: unfollowed_user)
    end

    it "returns posts from followed users and own posts" do
      feed_posts = user.feed_posts
      expect(feed_posts).to include(user.posts.first)
      expect(feed_posts).to include(followed_user.posts.first)
      expect(feed_posts).to_not include(unfollowed_user.posts.first)
    end
  end

  # Authentication
  describe "password" do
    it "requires password when creating a new user" do
      user = User.new(username: "newuser", email: "new@example.com")
      expect(user).to_not be_valid
    end

    it "authenticates with correct password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("wrongpassword")).to be_falsey
    end
  end
end