class CreateLeaveApplications < ActiveRecord::Migration
  def change
    create_table :leave_applications do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.text :reason, null: false
      t.integer :leave_id, null: false
      t.integer :status_id, default: 1

      t.timestamps
    end
  end
end
