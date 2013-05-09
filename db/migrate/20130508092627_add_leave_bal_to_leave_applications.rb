class AddLeaveBalToLeaveApplications < ActiveRecord::Migration
  def up
  	add_column :leave_applications,:leave_bal,:integer
  end
end
