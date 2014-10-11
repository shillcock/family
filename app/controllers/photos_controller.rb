class PhotosController < ApplicationController
  before_action :set_photo

  def download
    redirect_to photo_path
  end

  def view
    redirect_to photo_path
  end

  private

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_path
      @photo.image_url(params[:version])
    end
end

