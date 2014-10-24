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

  mount_uploader :image, ImageUploader

  scope :random, -> { order("RANDOM()") }
end
