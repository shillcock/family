class User < ActiveRecord::Base

  validates_presence_of :email
  validates_presence_of :uid
  validates_presence_of :provider

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize().tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.avatar_url = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def admin?
    email && ENV["ADMIN_EMAILS"].to_s.include?(email)
  end
end

