class ChangeStateInShippingAddresses < ActiveRecord::Migration
  def self.up
	change_column :shipping_addresses, :state, :string
  end

  def self.down
	change_column :shipping_addresses, :state, :integer
  end
end
