# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text             not null
#  commentable_id   :integer          not null
#  commentable_type :string           not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  latitude         :float
#  longitude        :float
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user
  has_many :hearts, as: :lovable, dependent: :destroy
  has_many :photos, as: :photoable, dependent: :destroy

  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :content, presence: true
  validates :commentable, presence: true
  validates :user, presence: true

  scope :sorted, -> { order(created_at: :asc) }

  def loved_by?(user)
    hearts.exists?(user: user)
  end

  def user_avatar(size = nil)
    user.avatar_url(size)
  end

  def user_name
    user.name
  end
end

