# == Schema Information
#
# Table name: hearts
#
#  id           :integer          not null, primary key
#  lovable_id   :integer          not null
#  lovable_type :string           not null
#  user_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_hearts_on_lovable_id_and_lovable_type  (lovable_id,lovable_type)
#  index_hearts_on_user_id                      (user_id)
#  index_hearts_on_user_id_and_lovable_id       (user_id,lovable_id)
#

require 'test_helper'

class HeartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
