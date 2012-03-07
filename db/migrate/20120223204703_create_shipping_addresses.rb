class CreateShippingAddresses < ActiveRecord::Migration
  def self.up
    create_table :shipping_addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :state
      t.integer :zip
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_addresses
  end
end
