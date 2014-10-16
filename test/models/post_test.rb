# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
