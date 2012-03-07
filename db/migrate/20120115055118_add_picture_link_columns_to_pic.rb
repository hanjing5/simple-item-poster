class AddPictureLinkColumnsToPic < ActiveRecord::Migration
  def self.up
	change_table :pics do |t|
		t.has_attached_file :picture_link
	end

  end

  def self.down
	drop_attached_file :pics, :picture_link
  end
end
