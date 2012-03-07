class ChangeDetailsInPic2 < ActiveRecord::Migration
  def self.up
	remove_column :pics, :ad_id
	add_column :pics, :company_id, :integer
	add_column :pics, :cost_per_redeem, :integer
	add_column :pics, :limit, :integer
	add_column :pics, :redeemed, :integer
  end

  def self.down
  end
end
