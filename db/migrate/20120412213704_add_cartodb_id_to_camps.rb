class AddCartodbIdToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :cartodb_id, :integer

  end
end
