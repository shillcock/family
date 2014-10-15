class CommentDecorator < Draper::Decorator
  delegate_all

  delegate :build

  def created_at
    h.content_tag :span, class: 'time' do
      object.created_at.strftime("%a %m/%d/%y")
    end
  end

  def content
    markdown.render(object.content)
  end

  private
    def markdown
      @markdown ||= MarkdownService.new
    end
end

