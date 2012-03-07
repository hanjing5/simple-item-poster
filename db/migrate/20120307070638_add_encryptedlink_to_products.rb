class AddEncryptedlinkToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :encrypted_link, :string
  end

  def self.down
    remove_column :products, :encrypted_link
  end
end
