class PhotosController < ApplicationController
  before_action :set_photo

  def download
    send_file photo_path, x_sendfile: true
  end

  def view
    send_file photo_path, disposition: "inline"
  end

  private

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_path
      @photo.image_url(params[:version])
    end
end

