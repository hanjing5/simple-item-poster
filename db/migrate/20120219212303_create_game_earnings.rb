class CreateGameEarnings < ActiveRecord::Migration
  def self.up
    create_table :game_earnings do |t|
      t.integer :game_id
      t.integer :coupon_id
      t.decimal :earnings, :scale=>2, :precision=>9, :default=>0
      t.decimal :coupon_cost, :scale=>2, :precision=>9, :default=>0
		
	  t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_earnings
  end
end
