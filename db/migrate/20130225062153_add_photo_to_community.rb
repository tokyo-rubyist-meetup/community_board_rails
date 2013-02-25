class AddPhotoToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :photo, :string
  end
end
