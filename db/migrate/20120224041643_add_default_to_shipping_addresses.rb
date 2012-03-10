class AddDefaultToShippingAddresses < ActiveRecord::Migration
  def self.up
    add_column :shipping_addresses, :default, :boolean, :default=>false
  end

  def self.down
    remove_column :shipping_addresses, :default
  end
end
