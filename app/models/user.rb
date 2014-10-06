# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  first_name :string
#  last_name  :string
#  birthday   :date
#  image      :string
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  validates_presence_of :email

  def self.from_omniauth(auth)
    if user = find_by(email: auth.info.email)
      user.update_from_omniauth(auth)
      user
    else
      User.new
    end
  end

  def update_from_omniauth(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.email = auth.info.email
    self.image = auth.info.image
    self.save!
  end
end
