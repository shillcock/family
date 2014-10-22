# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  photoable_id   :integer
#  photoable_type :string
#  image          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_photos_on_photoable_id_and_photoable_type  (photoable_id,photoable_type)
#

class Photo < ActiveRecord::Base
  belongs_to :photoable, polymorphic: true
  has_many :hearts, as: :lovable, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :random, -> { order("RANDOM()") }

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
