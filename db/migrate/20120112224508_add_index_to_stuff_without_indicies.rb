class AddIndexToStuffWithoutIndicies < ActiveRecord::Migration
  def self.up
  	add_index :ads, :company_id
  	add_index :products, :company_id
  	add_index :products, :ext_product_id 
  	add_index :products, :name
  	add_index :products, [:company_id, :ext_product_id], :unique => true
  	add_index :products, [:company_id, :name]
  end

  def self.down
  	remove_index :ads, :company_id
  	remove_index :products, :company_id
  	remove_index :products, :ext_product_id 
  	remove_index :products, :name
  	remove_index :products, [:company_id, :ext_product_id]
  	remove_index :products, [:company_id, :name]
  end
end
