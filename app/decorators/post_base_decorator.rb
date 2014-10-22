class PostBaseDecorator < Draper::Decorator
  decorates_association :photos
  decorates_association :hearts
  decorates_association :user

  def content
    markdown.render(object.content)
  end

  def posted_at
    "#{h.time_ago_in_words(object.created_at)} ago"
  end

  def created_at
    object.created_at.to_formatted_s(:short)
  end

  def user_name
    user.first_name
  end

  def user_avatar(*args)
    user.avatar_url(*args)
  end

  #def build_comment(user)
  #  object.comments.build(user: user)
  #end

  private
    def markdown
      @markdown ||= MarkdownService.new
    end
end

