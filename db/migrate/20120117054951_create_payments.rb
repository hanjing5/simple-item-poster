class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.string :method
      t.string :info

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
