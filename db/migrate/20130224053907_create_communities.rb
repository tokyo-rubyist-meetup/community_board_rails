class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.references :owner, null: false

      t.timestamps
    end
    add_index :communities, :owner_id
  end
end
