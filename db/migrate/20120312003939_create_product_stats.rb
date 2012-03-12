class CreateProductStats < ActiveRecord::Migration
  def self.up
    create_table :product_stats do |t|
      t.boolean :impression, :default=>false
      t.boolean :purchase, :default=>false
      t.integer :product_id
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_stats
  end
end
