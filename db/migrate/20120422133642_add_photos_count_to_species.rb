class AddPhotosCountToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :photos_count, :integer

  end
end
