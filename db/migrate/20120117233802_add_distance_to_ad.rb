class AddDistanceToAd < ActiveRecord::Migration
  def self.up
  	add_column :ads, :distance, :decimal, :default => 0.0
  end

  def self.down
	remove_column :ads, :distance
  end
end
