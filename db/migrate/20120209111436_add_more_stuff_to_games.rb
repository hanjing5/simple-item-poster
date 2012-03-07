class AddMoreStuffToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :impressions, :integer,:default => 0
    add_column :games, :earnings, :decimal, :precision => 50, :default => 0.00
  end

  def self.down
    remove_column :games, :earnings
    remove_column :games, :impressions
  end
end
