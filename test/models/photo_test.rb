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

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
