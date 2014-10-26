class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :view]

  def index
    @photos = Photo.random.limit(52)
  end

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

