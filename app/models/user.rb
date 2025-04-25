# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  # Follow relationships
  has_many :follower_relationships, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  
  has_many :following_relationships, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :following_relationships, source: :following
  
  # Notifications
  has_many :received_notifications, class_name: 'Notification', foreign_key: :recipient_id, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  
  def feed_posts
    following_ids = following.pluck(:id)
    Post.where(user_id: following_ids + [id]).order(created_at: :desc)
  end
end