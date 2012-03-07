class CreateTmpUsers < ActiveRecord::Migration
  def self.up
    create_table :tmp_users do |t|
      t.string :email
      t.integer :coupon_id
      t.integer :game_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_users
  end
end
