class AddColumnsToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :dispute, :boolean,:default=>false
    add_column :invoices, :paid, :boolean,:default=>false
  end

  def self.down
    remove_column :invoices, :paid
    remove_column :invoices, :dispute
  end
end
