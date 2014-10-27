class AddUserReferenceToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :user, index: true

    reversible do |dir|
      dir.up do
        # update all photos to belong to a user
        Photo.find_each do |photo|
          puts "photo[#{photo.id}].user[#{photo.photoable.user.first_name}]"
          photo.user = photo.photoable.user
          photo.save!
        end
      end
    end

    change_column_null(:photos, :user_id, false)
  end
end

