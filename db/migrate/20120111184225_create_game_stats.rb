class CreateGameStats < ActiveRecord::Migration
  def self.up
    create_table :game_stats do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :plays
      t.decimal :duration_average

      t.timestamps
    end
    add_index :game_stats, :game_id
    add_index :game_stats, :user_id
    add_index :game_stats, [:game_id, :user_id], :unique => true
  end

  def self.down
    drop_table :game_stats
  end
end
