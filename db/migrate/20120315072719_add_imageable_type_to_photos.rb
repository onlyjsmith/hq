class AddImageableTypeToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :imageable_type, :integer

  end
end
