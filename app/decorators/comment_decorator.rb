class CommentDecorator < Draper::Decorator
  delegate_all

  delegate :build

  # def created_at
  #   h.content_tag :span, class: 'time' do
  #     object.created_at.strftime("%a %m/%d/%y")
  #   end
  # end

  def content
    markdown.render(object.content)
  end

  def commented_at
    "#{h.time_ago_in_words(object.created_at)} ago"
  end

  def created_at
    object.created_at.to_formatted_s(:short)
  end

  def user
    UserDecorator.decorate object.user
  end

  def user_gravatar(*args)
    user.gravatar(*args)
  end

  private
    def markdown
      @markdown ||= MarkdownService.new
    end
end

