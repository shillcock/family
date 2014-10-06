class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
