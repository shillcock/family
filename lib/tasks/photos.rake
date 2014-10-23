namespace :photos do
  task :recreate_versions do
    Photo.find_each do |photo|
      begin
        puts  "processing: #{photo.id}..."
        # photo.process_your_uploader_upload = true # only if you use carrierwave_backgrounder
        photo.image.cache_stored_file!
        photo.image.retrieve_from_cache!(photo.image.cache_name)
        photo.image.recreate_versions!
        photo.save!
      rescue => e
        puts  "ERROR: Phtoto: #{photo.id} -> #{e.to_s}"
      end
    end
  end
end
