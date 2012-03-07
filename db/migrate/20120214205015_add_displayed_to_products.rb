class AddDisplayedToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :displayed, :integer, :default=>0
  end

  def self.down
    remove_column :products, :displayed
  end
end
