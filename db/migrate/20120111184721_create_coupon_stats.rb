class CreateCouponStats < ActiveRecord::Migration
  def self.up
    create_table :coupon_stats do |t|
      t.integer :coupon_id
      t.integer :user_id
      t.integer :interactions

      t.timestamps
    end
    add_index :coupon_stats, :coupon_id
    add_index :coupon_stats, :user_id
    add_index :coupon_stats, [:coupon_id, :user_id], :unique => true
  end

  def self.down
    drop_table :coupon_stats
  end
end
