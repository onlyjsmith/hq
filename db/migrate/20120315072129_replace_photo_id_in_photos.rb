class ReplacePhotoIdInPhotos < ActiveRecord::Migration
  def up
    add_column :photos, :imageable_id, :integer
    remove_column :species, :photo_id
  end

  def down
  end
end