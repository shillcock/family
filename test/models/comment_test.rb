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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
