class RenameNotificationToSubscription < ActiveRecord::Migration[5.0]
  def change
    rename_table :notifications, :subscriptions
  end
end
