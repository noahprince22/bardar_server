class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.integer :yelp_id
      t.string :name
      t.integer :freshness

      t.timestamps null: false
    end
  end
end
