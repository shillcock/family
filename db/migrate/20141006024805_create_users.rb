class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, index: true, null: false, unique: true
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.string :image
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
  end
end

