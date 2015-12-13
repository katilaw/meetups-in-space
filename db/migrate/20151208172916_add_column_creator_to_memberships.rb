class AddColumnCreatorToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :creator, :boolean, null: false, default: false
  end
end
