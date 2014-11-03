# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
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

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user
  has_many :hearts, as: :lovable, dependent: :destroy
  has_many :photos, as: :photoable

  accepts_nested_attributes_for :photos

  validates :content, presence: true, unless: "photos.any?"
  validates :commentable, presence: true
  validates :user, presence: true

  scope :sorted, -> { order(created_at: :asc) }

  before_save :process_content
  after_save :process_love

  def loved_by?(user)
    hearts.exists?(user: user)
  end

  def send_notifications!
    return unless @notify
    if ENV["OVERRIDES_SMS_TO"]
      user = User.find_by(phone_number: ENV["OVERRIDES_SMS_TO"])
      SendCommentNotificationJob.perform_later(self, user) if user
    else
      users = User.all - [self.user]
      users.each do |user|
        SendCommentNotificationJob.perform_later(self, user)
      end
    end
  end

  private

    def process_content
      if content.starts_with?("!!")
        @notify = false
        self.content.slice!(0..1)
      elsif content == "<3" or content == "❤"
        @notify = false
      else
        @notify = true
      end
      true
    end

    def process_love
      if content.include?("<3") or content.include?("❤")
        commentable.hearts.create(user: user)
      end
    end
end

