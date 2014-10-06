class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :post, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
