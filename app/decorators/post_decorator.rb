class PostDecorator < SimpleDecorator
  def content
    markdown.render(object.content)
  end

  def user_name
    user.first_name
  end

  def user_avatar(*args)
    user.avatar_url(*args)
  end

  private
    def markdown
      @markdown ||= MarkdownService.new
    end
end

