module PhotosHelper
  def photo_image(photo, params)
    view_photo_path(photo, version: params[:version] || :small)
  end
end

