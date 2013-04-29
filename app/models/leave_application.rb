class LeaveApplication < ActiveRecord::Base
  attr_accessible :end_date, :leave_id, :reason, :start_date, :status_id, :employee_id

  validates :end_date, :start_date, :leave_id, :reason, :employee_id, :status_id, presence: true

  belongs_to :status
  belongs_to :leave
  belongs_to :employee


  def self.myDepartment(employee)
  	select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(employee_id:employee)
  end

end
