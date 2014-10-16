class AddLatLonToComments < ActiveRecord::Migration
  def change
    add_column :comments, :latitude, :float
    add_column :comments, :longitude, :float
  end
end
