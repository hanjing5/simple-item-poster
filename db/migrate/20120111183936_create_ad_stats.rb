class CreateAdStats < ActiveRecord::Migration
  def self.up
    create_table :ad_stats do |t|
      t.integer :ad_id
      t.integer :user_id
      t.integer :views
      t.integer :clicks
      t.integer :closes

      t.timestamps
    end
    add_index :ad_stats, :ad_id
    add_index :ad_stats, :user_id
    add_index :ad_stats, [:ad_id, :user_id], :unique => true
  end

  def self.down
    drop_table :ad_stats
  end
end
