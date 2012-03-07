class Type < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness =>  true
end
# == Schema Information
#
# Table name: types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

