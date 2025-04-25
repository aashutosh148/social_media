class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references(to_table: :recipient)
      t.references(to_table: :actor)
      t.string :action
      t.references(:notifiable, polymorphic: true)
      t.boolean :read

      t.timestamps
    end
  end
end
