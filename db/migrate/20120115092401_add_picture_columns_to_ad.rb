class AddPictureColumnsToAd < ActiveRecord::Migration
  def self.up
	change_table :ads do |t|
                t.has_attached_file :picture
        end


  end

  def self.down
     drop_attached_file :ads, :picture
  end
end
