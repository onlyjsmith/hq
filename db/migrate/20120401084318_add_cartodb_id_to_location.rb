class AddCartodbIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :cartodb_id, :integer

  end
end
