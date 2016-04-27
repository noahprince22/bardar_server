class AddBarIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :bar_id, :integer
    add_index :reports, :bar_id
  end
end
