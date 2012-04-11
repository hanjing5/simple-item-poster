class AddAdminToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :admin, :boolean,:default=>false
  end

  def self.down
    remove_column :companies, :admin
  end
end
