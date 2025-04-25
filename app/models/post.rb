class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image
  
  validates :content, presence: true, length: { maximum: 500 }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  after_create :schedule_feed_update
  
  private
  
  def schedule_feed_update
    FeedUpdateWorker.perform_async(id)
  end
end