# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           not null
#  first_name                :string
#  last_name                 :string
#  birthday                  :date
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  phone_number              :string           not null
#  auth_token                :string           not null
#  sms_token                 :string
#  sms_confirmed_at          :datetime
#  last_notification_sent_at :datetime         default("2014-10-31 20:31:07.471607"), not null
#
# Indexes
#
#  index_users_on_email         (email)
#  index_users_on_phone_number  (phone_number) UNIQUE
#

class User < ActiveRecord::Base
  has_many :posts, inverse_of: :user
  has_many :comments
  has_many :hearts
  has_many :photos

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_create { generate_token(:auth_token) }

  def admin?
    false
  end

  def throttle_notifications?
    #turn off throttling for now
    #[3].include?(id) # throttle notification for Renee
    false
  end

  def avatar_url
    "#{id}.png"
  end

  def to_param
    first_name.parameterize
  end

  def love(lovable)
    self.hearts.create(lovable: lovable) unless hearts.exists?(lovable: lovable)
  end

  def loves?(lovable)
    lovable.hearts.exists?(user: self)
  end

  def sms_confirmed?
    !!sms_confirmed_at
  end

  def generate_sms_token!
    self.sms_confirmed_at = nil
    generate_token(:sms_token)
    save!
  end

  private

    def generate_token(column)
      begin
        token = SecureRandom.urlsafe_base64
        self[column] = Digest::SHA1.hexdigest(token).to_s
      end while User.exists?(column => self[column])
    end
end

