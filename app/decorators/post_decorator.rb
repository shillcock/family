class PostDecorator < Draper::Decorator
  decorates_association :comments

  delegate_all

  def created_at
    h.content_tag :span, class: 'time' do
      object.created_at.strftime("%a %m/%d/%y")
    end
  end

  def content
    markdown.render(object.content)
  end

  def build_comment(user)
    object.comments.build(user: user)
  end

  private
    def markdown
      @markdown ||= MarkdownService.new
    end
end

