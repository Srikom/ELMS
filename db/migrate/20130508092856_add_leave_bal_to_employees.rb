class AddLeaveBalToEmployees < ActiveRecord::Migration
  def up
  	add_column :employees,:leave_bal,:integer, default: 30
  end
end
