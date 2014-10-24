module ApplicationHelper
  def markdown(text)
    MarkdownService.new.render(text)
  end

  def user_avatar_tag(user, size=50)
    image_tag user.avatar_url, width: size, height: size, class: "avatar"
  end
end

