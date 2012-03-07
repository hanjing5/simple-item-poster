class AddMetaDataColumnToProductAdCoupon < ActiveRecord::Migration
  def self.up
	add_column :products, :meta_data, :text
	add_column :coupons, :meta_data, :text
	add_column :ads, :meta_data, :text
  end

  def self.down
  end
end
