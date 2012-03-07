class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :shipping_address_id
      t.string :credit_card_token
      t.decimal :price, :scale=>2, :precision=>8, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
