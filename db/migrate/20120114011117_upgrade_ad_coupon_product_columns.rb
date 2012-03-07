class UpgradeAdCouponProductColumns < ActiveRecord::Migration
  def self.up
  	add_column :ads, :name, :string
  	add_column :ads, :description, :text
  	add_column :ads, :cost_per_impression, :decimal
  	add_column :ads, :cost_per_click, :decimal
  	add_column :ads, :cost_per_purchase, :decimal 
  	add_column :ads, :love_hate, :integer
  	add_column :ads, :relief_fear, :integer
  	add_column :ads, :excite_bore, :integer
  	add_column :ads, :happy_sad, :integer
  	add_column :ads, :funny_serious, :integer
  	add_column :ads, :sexy_disgust, :integer 
  	
  	add_column :coupons, :name, :string
  	add_column :coupons, :description, :text
  	add_column :coupons, :cost_per_redeem, :decimal
  	add_column :coupons, :limit, :integer
  	add_column :coupons, :redeemed, :integer
  	add_column :coupons, :ext_coupon_id, :integer
  	
  	add_index :coupons, [:company_id, :ext_coupon_id], :unique => true
  	
  end

  def self.down
  	remove_index :coupons, [:company_id, :ext_coupon_id]
  	
	remove_column :ads, :name
	remove_column :ads, :description
	remove_column :ads, :cost_per_impression
	remove_column :ads, :cost_per_click
	remove_column :ads, :cost_per_purchase 
	remove_column :ads, :love_hate
	remove_column :ads, :relief_fear
	remove_column :ads, :excite_bore
	remove_column :ads, :happy_sad
	remove_column :ads, :funny_serious
	remove_column :ads, :sexy_disgust 

	remove_column :coupons, :name
	remove_column :coupons, :description
	remove_column :coupons, :cost_per_redeem
	remove_column :coupons, :limit
	remove_column :coupons, :redeemed
	remove_column :coupons, :ext_coupon_id
	

  end
end
