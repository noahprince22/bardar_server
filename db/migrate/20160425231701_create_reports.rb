class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :line_length
      t.float :cover_charge
      t.float :ratio
      t.float :avg_age

      t.timestamps null: false
    end
  end
end
