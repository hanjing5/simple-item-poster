class CreatePreviews < ActiveRecord::Migration
  def self.up
    create_table :previews do |t|
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :previews
  end
end
