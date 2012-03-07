class AddStuffToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :price, :decimal, :precision=>8, :scale=>2, :default=>0
    add_column :products, :clicked_through, :integer, :default=>0
    add_column :products, :purchased, :integer, :default=>0
  end

  def self.down
    remove_column :products, :purchased
    remove_column :products, :clicked_through
    remove_column :products, :price
  end
end
