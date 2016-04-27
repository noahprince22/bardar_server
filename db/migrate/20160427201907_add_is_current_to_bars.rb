class AddIsCurrentToBars < ActiveRecord::Migration
  def change
    add_column :bars, :is_current, :boolean
  end
end
