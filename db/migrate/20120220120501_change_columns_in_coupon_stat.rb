class ChangeColumnsInCouponStat < ActiveRecord::Migration
  def self.up
	remove_column :coupon_stats, :interactions
	add_column :coupon_stats, :game_id, :integer
	add_column :coupon_stats, :click_through, :boolean, :default=>false
	add_column :coupon_stats, :impression, :boolean, :default=>false
  end

  def self.down
	remove_column :coupon_stats, :game_id
	add_column :coupon_stats, :interactions, :integer
	remove_column :coupon_stats, :impression
	remove_column :coupon_stats, :click_through
  end
end
