class AddIpToProductStats < ActiveRecord::Migration
  def self.up
    add_column :product_stats, :ip, :string
  end

  def self.down
    remove_column :product_stats, :ip
  end
end
