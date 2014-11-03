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

  scope :sort_by_created_at, -> { order(created_at: :desc) }
  scope :sort_by_updated_at, -> { order(updated_at: :desc) }

  before_save :process_content

  def loved_by?(user)
    hearts.exists?(user: user)
  end

  def send_notifications!
    return unless @notify
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

  private

    def process_content
      if content.starts_with?("!!")
        @notify = false
        self.content.slice!(0..1)
      else
        @notify = true
      end
    end
end

