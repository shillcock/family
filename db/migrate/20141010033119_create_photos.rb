class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true, index: true
      t.string :image, null: false

      t.timestamps null: false
    end
  end
end
