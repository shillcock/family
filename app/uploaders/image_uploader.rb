class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def store_dir
    # photos/2014/02/001
    uploaded_at = model.created_at.strftime("%Y/%m")
    dir = "#{model_dir}/#{uploaded_at}/#{model_id}"
    # dir = "#{model_dir}/#{Date.today.strftime("%Y/%m")}/#{model_id}"
    # dir.prepend("#{Rails.env}/") unless Rails.env.production?
    # dir
  end

  # def filename
  #   binding.pry
  #   build_name(:original) if original_filename
  # end

  version :xlarge do
    process resize_to_limit: [1200, 1200]

    def full_filename(for_file = model.image.file)
      build_name(:xlarge)
    end
  end

  version :large do
    process resize_to_limit: [1000, 1000]

    def full_filename(for_file = model.image.file)
      build_name(:large)
    end
  end

  version :medium do
    process resize_to_limit: [800, 800]

    def full_filename(for_file = model.image.file)
      build_name(:medium)
    end
  end

   version :small do
    process resize_to_limit: [600, 600]

    def full_filename(for_file = model.image.file)
      build_name(:small)
    end
  end

  version :square do
    process crop: [250, 250]

    def full_filename(for_file = model.image.file)
      build_name(:square)
    end
  end

  version :thumbnail do
    process resize_to_limit: [150, 150]

    def full_filename(for_file = model.image.file)
      build_name(:thumbnail)
    end
  end

  def crop(width, height)
    manipulate! do |img|
      img.resize "#{width}x#{height}^"
      img.combine_options do |cmd|
        cmd.gravity("Center")
        cmd.crop("#{width}x#{height}+0+0")
      end
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
    def build_name(version)
      "#{model_id}-#{version}.#{model.image.file.extension}"
    end

    def model_id
      "#{model.id.to_s.rjust(3, '0')}"
    end

    def model_dir
      model.class.to_s.pluralize.downcase.underscore
    end
end

