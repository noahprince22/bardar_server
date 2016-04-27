class ReplaceYelpIdWithYelpId < ActiveRecord::Migration
  def change
    change_column :bars, :yelp_id, :string
  end
end
