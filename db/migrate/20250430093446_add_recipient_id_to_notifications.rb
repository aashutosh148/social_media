class AddRecipientIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :recipient, foreign_key: { to_table: :users }
  end
end