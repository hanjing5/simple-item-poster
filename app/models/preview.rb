class Preview < ActiveRecord::Base
	belongs_to :product

	has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "75x75>" }
	
	attr_accessible :product_id, :picture

	validates_attachment_size :picture, :less_than => 3.megabytes
end

# == Schema Information
#
# Table name: previews
#
#  id                   :integer(4)      not null, primary key
#  product_id           :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#

