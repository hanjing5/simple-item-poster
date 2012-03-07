class AddPictureColumnsToCoupon < ActiveRecord::Migration
  def self.up
        change_table :coupons do |t|
                t.has_attached_file :picture
        end

  end

  def self.down
        drop_attached_file :coupons, :picture

  end
end
