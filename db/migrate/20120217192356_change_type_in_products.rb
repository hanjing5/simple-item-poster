class ChangeTypeInProducts < ActiveRecord::Migration
  def self.up
	remove_column :products, :type
	add_column :products, :product_type, :string
  end

  def self.down
	remove_column :products, :product_type
	add_column :products, :type, :string
  end
end
