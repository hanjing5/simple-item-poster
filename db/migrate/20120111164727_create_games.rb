class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :publisher_id

      t.timestamps
    end
    add_index :games, :publisher_id
  end

  def self.down
    drop_table :games
  end
end
