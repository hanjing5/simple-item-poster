class AddBuyeripToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :buyer_ip, :string
  end

  def self.down
    remove_column :invoices, :buyer_ip
  end
end
