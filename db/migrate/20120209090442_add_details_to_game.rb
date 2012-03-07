class AddDetailsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :meta_data, :string
    add_column :games, :name, :string
  end

  def self.down
    remove_column :games, :name
    remove_column :games, :meta_data
  end
end
