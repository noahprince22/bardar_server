class AddUserIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :user_id, :string
    add_index :reports, :user_id
  end
end
