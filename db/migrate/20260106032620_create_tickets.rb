class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :priority
      t.string :reporter
      t.string :assignee

      t.timestamps
    end
  end
end
