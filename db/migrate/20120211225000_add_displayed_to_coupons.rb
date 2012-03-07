class AddDisplayedToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :displayed, :integer, :default=>0
    add_column :coupons, :click_through, :integer, :default=>0
  end

  def self.down
    remove_column :coupons, :displayed
    remove_column :coupons, :click_through
  end
end
