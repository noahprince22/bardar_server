class AddLatLngToBars < ActiveRecord::Migration
  def change
    add_column :bars, :lat, :float
    add_column :bars, :lng, :float
  end
end
