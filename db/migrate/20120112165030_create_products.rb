class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :company_id
      t.integer :ext_product_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
