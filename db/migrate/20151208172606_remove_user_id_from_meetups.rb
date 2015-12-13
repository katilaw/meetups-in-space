class RemoveUserIdFromMeetups < ActiveRecord::Migration
  def change
    remove_column :meetups, :user_id, :integer
  end
end
