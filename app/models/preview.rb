class Preview < ActiveRecord::Base
	belongs_to :product

	has_attached_file :picture
	
	attr_accessible :product_id, :picture

	validates_attachment_size :picture, :less_than => 3.megabytes
end
