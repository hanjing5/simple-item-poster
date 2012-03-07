class AddLinkToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :link, :string
  end

  def self.down
    remove_column :products, :link
  end
end
