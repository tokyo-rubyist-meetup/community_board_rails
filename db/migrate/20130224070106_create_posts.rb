class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :community
      t.references :user
      t.text :text

      t.timestamps
    end
    add_index :posts, :community_id
    add_index :posts, :user_id
  end
end
