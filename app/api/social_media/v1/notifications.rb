module SocialMedia
  module V1
    class Notifications < Grape::API
      version 'v1', using: :path
      format :json
      
      resource :notifications do
        desc 'Get current user notifications'
        get do
          authenticate!
          
          notifications = current_user.received_notifications
            .includes(:actor)
            .order(created_at: :desc)
            .limit(20)
          
          notifications.map do |notification|
            {
              id: notification.id,
              action: notification.action,
              read: notification.read,
              created_at: notification.created_at,
              actor: {
                id: notification.actor.id,
                username: notification.actor.username,
                avatar_url: notification.actor.avatar_url
              },
              notifiable_type: notification.notifiable_type,
              notifiable_id: notification.notifiable_id
            }
          end
        end
        
        desc 'Mark notification as read'
        params do
          requires :id, type: Integer, desc: 'Notification ID'
        end
        put ':id' do
          authenticate!
          
          notification = current_user.received_notifications.find(params[:id])
          
          if notification.update(read: true)
            { status: 'success' }
          else
            error!({ errors: notification.errors.full_messages }, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!({ error: 'Notification not found' }, 404)
        end
        
        desc 'Mark all notifications as read'
        put :read_all do
          authenticate!
          
          current_user.received_notifications.update_all(read: true)
          { status: 'success' }
        end
      end
    end
  end
end