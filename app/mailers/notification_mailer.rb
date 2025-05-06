# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
  def like_notification(like)
    @like = like
    @post = like.post
    @liker = like.user
    @post_owner = @post.user
    
    return unless @post_owner.email.present?
    
    mail(
      to: "aashutosh.singh@gocomet.com",
      subject: "liked your post"
    )
  end
end