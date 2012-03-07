class ChangeClickThroughInProducts < ActiveRecord::Migration
  def self.up
	add_column :products, :click_through, :integer, :default=>0
  end

  def self.down
	remove_column :products, :click_through
  end
end
