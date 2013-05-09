class CreateDeletions < ActiveRecord::Migration
  def change
    create_table :deletions do |t|
      t.text :reason, null: false
      t.integer :leave_application_id, null: false

      t.timestamps
    end
  end
end
