class User < ActiveRecord::Base
  has_many :posts
  has_many :comments

  validates_presence_of :email
end
