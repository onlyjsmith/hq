class CreateTribes < ActiveRecord::Migration
  def change
    create_table :tribes do |t|
      t.string :name
      t.integer :location_id
      t.integer :species_id

      t.timestamps
    end
  end
end
