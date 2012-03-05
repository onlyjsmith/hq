class CreateSpecies < ActiveRecord::Migration
  def change
    create_table :species do |t|
      t.string :common_name
      t.string :binomial

      t.timestamps
    end
  end
end
