class AddUniqueIndexToUsersUsername < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :username, unique: true, name: 'unique_users_username'
  end
end