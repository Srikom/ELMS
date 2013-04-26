class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.string :leave_name, null: false

      t.timestamps
    end
  end
end
