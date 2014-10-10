# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
  has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy
  has_many :hearts, as: :lovable, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true

  def loved_by?(user)
    hearts.where(user: user).any?
  end
end

