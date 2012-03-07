# == Schema Information
#
# Table name: pictures
#
#  id               :integer(4)      not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  pic_file_name    :string(255)
#  pic_content_type :string(255)
#  pic_file_size    :integer(4)
#  pic_updated_at   :datetime
#

class Picture < ActiveRecord::Base
end
