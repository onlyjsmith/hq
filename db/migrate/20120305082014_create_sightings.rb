class CreateSightings < ActiveRecord::Migration
  def change
    create_table :sightings do |t|
      t.string :what
      t.string :where
      t.string :when
      t.string :how
      t.string :who

      t.timestamps
    end
  end
end
