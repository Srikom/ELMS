class LeaveApplication < ActiveRecord::Base
  attr_accessible :end_date, :leave_id, :reason, :start_date, :status_id, :employee_id

  validates :end_date, :start_date, :leave_id, :reason, :employee_id, :status_id, presence: true

  belongs_to :status
  belongs_to :leave
  belongs_to :employee

  scope :leaveApproved, select("employees.id,employees.name,leave_applications.start_date").joins(:employee).where(status_id:5)

  def self.myDepartment(employee)
  	select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(employee_id:employee)
  end

  def self.appDetails(application)
  	select("*,leave_applications.id,(julianday(end_date)-julianday(start_date)) AS date_diff").joins(:status,:leave).where(id:application)
  end 

  def self.myArchive(employee)
  	select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where("employee_id = ? AND status_id = 3 OR status_id = 5",employee)
  end



end
