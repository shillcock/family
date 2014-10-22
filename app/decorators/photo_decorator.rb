class PhotoDecorator < Draper::Decorator
  delegate_all

  def image(params = {})
    h.view_photo_path(object, version: params[:version] || :small)
  end
end

