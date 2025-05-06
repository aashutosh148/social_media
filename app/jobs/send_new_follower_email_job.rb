class SendNewFollowerEmailJob < ApplicationJob
  queue_as :default

  def perform(followed_user_id, follower_id)
    followed_user = User.find(followed_user_id)
    follower = User.find(follower_id)

    UserMailer.new_follower_notification(followed_user, follower).deliver_now
  end
end
