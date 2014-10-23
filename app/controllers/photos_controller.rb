class PhotosController < ApplicationController
  before_action :set_photo

  def show
  end

  def view
    redirect_to photo_path
  end

  private

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_path
      if params[:version]
        @photo.image_url(params[:version])
      else
        @photo.image_url
      end
    end
end

