class AddPhotoIdToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :photo_id, :integer
  end
end