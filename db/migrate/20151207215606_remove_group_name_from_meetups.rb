class RemoveGroupNameFromMeetups < ActiveRecord::Migration
  def change
    remove_column :meetups, :group_name, :string
  end
end
