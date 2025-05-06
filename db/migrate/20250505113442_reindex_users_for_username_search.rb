class ReindexUsersForUsernameSearch < ActiveRecord::Migration[6.1]
  def change
    # Remove existing indexes on username
    remove_index :users, name: 'index_users_on_username', if_exists: true
    remove_index :users, name: 'unique_users_username', if_exists: true

    # Add a new index on LOWER(username) for efficient case-insensitive prefix search
    add_index :users, :username, using: :btree, name: 'unique_users_username'
  end
end