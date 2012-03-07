class CreatePics < ActiveRecord::Migration
  def self.up
    create_table :pics do |t|
      t.string :product
      t.integer :ad_id
      t.text :content
      t.text :meta_data

      t.timestamps
    end
  end

  def self.down
    drop_table :pics
  end
end
