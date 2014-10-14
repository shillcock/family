class AddPhoneAndAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string, null: false
    add_index :users, :phone_number, unique: true
    add_column :users, :auth_token, :string, null: false
    add_column :users, :sms_token, :string
    add_column :users, :sms_confirmed_at, :datetime
  end
end

