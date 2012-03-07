class AddTokensToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :token, :string
  end

  def self.down
    remove_column :games, :token
  end
end
