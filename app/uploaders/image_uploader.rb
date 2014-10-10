class ImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  version :standard do
    process resize_to_fill: [200, 200, :north]
  end

  version :thumbnail do
    resize_to_fit(50, 50)
  end

  version :bright_face do
    cloudinary_transformation :effect => "brightness:30", :radius => 20,
                              :width => 150, :height => 150, :crop => :thumb, :gravity => :face
  end
end

