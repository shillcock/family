class GravatarService
  def initialize(user)
    @user = user
  end

  def image_url(size = 80, type = "monsterid")
    hash = Digest::MD5.hexdigest(@user.email)
    "//www.gravatar.com/avatar/#{hash}?f=y&d=#{type}&s=#{size}"
  end
end

