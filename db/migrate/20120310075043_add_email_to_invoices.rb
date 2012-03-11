class AddEmailToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :email, :string
  end

  def self.down
    remove_column :invoices, :email
  end
end
