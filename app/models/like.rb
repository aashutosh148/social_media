class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :send_notification

  private

  def send_notification
    NotificationMailer.like_notification(self).deliver_now
    puts "Notification sent"
  end
end
