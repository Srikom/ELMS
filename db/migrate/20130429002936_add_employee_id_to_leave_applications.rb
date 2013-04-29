class AddEmployeeIdToLeaveApplications < ActiveRecord::Migration
  def self.up
  	add_column :leave_applications, :employee_id, :integer
  end

  def self.down

  end
end
