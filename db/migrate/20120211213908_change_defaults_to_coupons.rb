class ChangeDefaultsToCoupons < ActiveRecord::Migration
  def self.up
	remove_column :coupons, :cost_per_redeem
	add_column :coupons, :cost_per_redeem, :decimal, :precision => 8, :scale =>2, :default => 0
	change_column :coupons, :redeemed, :integer, :default=>0
  end

  def self.down
	remove_column :coupons, :cost_per_redeem
	add_column :coupons, :cost_per_redeem, :integer
	change_column :coupons, :redeemed, :integer
  end
end
