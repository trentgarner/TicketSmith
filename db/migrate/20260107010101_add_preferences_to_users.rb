class AddPreferencesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :assignee_name, :string
    add_column :users, :wip_limit, :integer, default: 3, null: false
    add_column :users, :reminders_enabled, :boolean, default: true, null: false
  end
end
