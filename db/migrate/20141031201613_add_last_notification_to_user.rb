class AddLastNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_notification_sent_at, :datetime, null: false, default: Time.zone.now
  end
end
