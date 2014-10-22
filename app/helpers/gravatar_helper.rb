module GravatarHelper
  def gravatar_image_tag(email, size, type = "monsterid")
    image_tag gravatar_image_url(email, size, type), height: size, width: size, class: "img-circle"
  end

  def gravatar_image_url(email, size, type = "monsterid")
    hash = Digest::MD5.hexdigest(email)
    "//www.gravatar.com/avatar/#{hash}?f=y&d=#{type}&s=#{size}"
  end
end

