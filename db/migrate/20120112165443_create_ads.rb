class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.integer :company_id
      t.integer :limit
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
