class RemoveLeaveBalFromLeaveApplications < ActiveRecord::Migration
  def up
  	remove_column :leave_applications, :leave_bal
  end
end
