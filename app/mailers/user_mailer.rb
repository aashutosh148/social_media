class UserMailer < ApplicationMailer
  def new_follower_notification(followed_user, follower)
    @followed_user = followed_user 
    @follower = follower 
    return unless @followed_user.email.present?

    mail(
      to: @followed_user.email,
      subject: "You have a new follower on OurApp!" 
    )
  end
end