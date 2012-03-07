class AddNameToPic < ActiveRecord::Migration
  def self.up
    add_column :pics, :name, :string
  end

  def self.down
    remove_column :pics, :name
  end
end
