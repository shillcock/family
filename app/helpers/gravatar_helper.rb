module GravatarHelper
  def gravatar_image_tag(email, size, type = "monsterid")
    hash = Digest::MD5.hexdigest(email)
    image_tag "//www.gravatar.com/avatar/#{hash}?f=y&d=#{type}&s=#{size}", height: size, width: size, class: "user-avatar img-circle"
  end
end

