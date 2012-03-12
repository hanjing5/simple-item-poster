class AddClickthroughToProductStats < ActiveRecord::Migration
  def self.up
    add_column :product_stats, :click_through, :boolean, :default=>false
  end

  def self.down
    remove_column :product_stats, :click_through
  end
end
