# == Schema Information
#
# Table name: attachments
#
#  id                :integer(4)      not null, primary key
#  product_id        :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer(4)
#  file_updated_at   :datetime
#
class Attachment < ActiveRecord::Base
	belongs_to :product

	has_attached_file :file
	
	attr_accessible :product_id, :file

	validates_attachment_size :file, :less_than => 100.megabytes
end

