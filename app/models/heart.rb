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

class Heart < ActiveRecord::Base
  belongs_to :lovable, polymorphic: true
  belongs_to :user

  validates :lovable, presence: true
  validates :user, presence: true,  uniqueness: { scope: [:lovable_id, :lovable_type] }
end

