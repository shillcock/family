module ApplicationHelper
  def markdown(text)
    MarkdownService.new.render(text)
  end
end

