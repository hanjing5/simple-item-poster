class AddStripecustomeridToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :stripe_customer_id, :string
  end

  def self.down
    remove_column :invoices, :stripe_customer_id
  end
end
