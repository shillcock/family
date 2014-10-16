class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    # photos/2014/02
    dir = "#{model_dir}/#{Date.today.strftime("%Y/%m")}"
    #dir.prepend("#{Rails.env}/") unless Rails.env.production?
    dir
  end

  # def filename
  #   if original_filename
  #     if model && model.read_attribute(mounted_as).present?
  #       model.read_attribute(mounted_as)
  #     else
  #       @name ||= "#{timestamp}_#{super}" if original_filename.present? and super.present?
  #     end
  #   end
  # end

  def filename
    build_name(:original) if original_filename
  end

  version :x3large do
    process :resize_to_limit => [1600, 1200]

    def full_filename(for_file = model.image.file)
      build_name(:x3large)
    end
  end

  version :x2large do
    process :resize_to_limit => [1280, 960]

    def full_filename(for_file = model.image.file)
      build_name(:x2large)
    end
  end

  version :xlarge do
    process :resize_to_limit => [1024, 768]

    def full_filename(for_file = model.image.file)
      build_name(:xlarge)
    end
  end

  version :large do
    process :resize_to_limit => [800, 600]

    def full_filename(for_file = model.image.file)
      build_name(:large)
    end
  end

   version :medium do
    process :resize_to_limit => [600, 450]

    def full_filename(for_file = model.image.file)
      build_name(:medium)
    end
  end

   version :small do
    process :resize_to_limit => [400, 300]

    def full_filename(for_file = model.image.file)
      build_name(:small)
    end
  end

  version :thumbnail do
    process :resize_to_fit => [150, 150]

    def full_filename(for_file = model.image.file)
      build_name(:thumbnail)
    end
  end

  version :tiny do
    process :resize_to_fit => [100, 100]

    def full_filename(for_file = model.image.file)
      build_name(:tiny)
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
    def build_name(version)
      "#{model.id.to_s.rjust(3, '0')}-#{version}.#{model.image.file.extension}"
    end

    def model_dir
      model.class.to_s.pluralize.downcase.underscore
    end

    def timestamp
      var = :"@#{mounted_as}_timestamp"
      model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
    end
end

