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

	has_attached_file :file, 

#	{
#		:url => "/system/:hash.:extension",
#		:hash_secret => "longSecretString"
#	},
			:storage => :s3,
			:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
			:url => "/system/:style/:hash.:extension",
			#:url  => ':style/:id/:basename.:extension',
			:hash_secret => "wtfisthisbullshit11",
			#:path => ':style/:id/:basename.:extension',
			:bucket => "#{Configuration.bucket_name}"

	
	attr_accessible :product_id, :file

	validates_attachment_size :file, :less_than => 25.megabytes
end


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

