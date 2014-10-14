# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string           not null
#  first_name       :string
#  last_name        :string
#  birthday         :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  phone_number     :string           not null
#  auth_token       :string           not null
#  sms_token        :string
#  sms_confirmed_at :datetime
#
# Indexes
#
#  index_users_on_email         (email)
#  index_users_on_phone_number  (phone_number) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
