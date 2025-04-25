class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.integer :likes_count
      t.integer :comments_count

      t.timestamps
    end
  end
end
