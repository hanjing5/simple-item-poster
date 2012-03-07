class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :credit_card_token
  
  # Relational stuff
  has_many :coupon_stats
  has_many :coupons, :through => :coupon_stats
  
  has_many :ad_stats
  has_many :ads, :through => :ad_stats
  
  has_many :game_stats
  has_many :games, :through => :game_stats
  
  # Payment methods
  has_many :payments
  has_many :shipping_addresses

  #def verify_password?(password)
  #  encryptor_class = Devise::Encryptors.const_get(Devise.encryptor.to_s.classify)
  #  encryptor_digest = encryptor_class.digest(password, Devise.stretches, self.password_salt, Devise.pepper)
  #  encryptor_digest == self.encrypted_password
  #end
end


# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  token                  :string(255)
#  credit_card_token      :string(255)
#

