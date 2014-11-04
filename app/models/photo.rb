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
#  user_id        :integer          not null
#  deleted_at     :datetime
#
# Indexes
#
#  index_photos_on_deleted_at                       (deleted_at)
#  index_photos_on_photoable_id_and_photoable_type  (photoable_id,photoable_type)
#  index_photos_on_user_id                          (user_id)
#

class Photo < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :photoable, polymorphic: true
  belongs_to :user

  mount_uploader :image, ImageUploader

  scope :random, -> { order("RANDOM()") }
end
