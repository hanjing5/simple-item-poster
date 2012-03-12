class AddPaypalemailToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :paypal_email, :string
  end

  def self.down
    remove_column :companies, :paypal_email
  end
end
