class CreateCamps < ActiveRecord::Migration
  def change
    create_table :camps do |t|
      t.string :name
      t.integer :company_id
      t.integer :location_id

      t.timestamps
    end
  end
end
