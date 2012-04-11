class AddVirtualToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :virtual, :boolean, :default=>true
  end

  def self.down
    remove_column :products, :virtual
  end
end
