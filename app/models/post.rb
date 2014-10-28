# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
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

class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
  has_many :comments, -> { sorted }, as: :commentable, dependent: :destroy
  has_many :hearts, as: :lovable, dependent: :destroy
  has_many :photos, as: :photoable

  accepts_nested_attributes_for :photos

  validates :user, presence: true
  validates :content, presence: true, unless: "photos.any?"

  scope :sorted, -> { order(created_at: :desc) }

  def loved_by?(user)
    hearts.exists?(user: user)
  end

  def send_notifications!
    if ENV["OVERRIDES_SMS_TO"]
      user = User.find_by(phone_number: ENV["OVERRIDES_SMS_TO"])
      SendPostNotificationJob.perform_later(self, user) if user
    else
      users = User.all - [self.user]
      users.each do |user|
        SendPostNotificationJob.perform_later(self, user)
      end
    end
  end
end

