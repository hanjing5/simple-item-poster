class ChangeDetailsInPic < ActiveRecord::Migration
  def self.up
    remove_column :pics, :product
    add_column :pics, :product, :integer
  end

  def self.down
  end
end
