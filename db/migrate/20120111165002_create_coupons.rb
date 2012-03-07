class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.integer :company_id

      t.timestamps
    end
    add_index :coupons, :company_id
  end

  def self.down
    drop_table :coupons
  end
end
