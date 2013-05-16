class LeaveApplication < ActiveRecord::Base
  attr_accessible :end_date, :leave_id, :reason, :start_date, :status_id, :employee_id, :leave

  validates :end_date, :start_date, :leave_id, :reason, :employee_id, :status_id, presence: true

  belongs_to :status
  belongs_to :leave
  belongs_to :employee

  

  def self.dateDiff(lid)
    select("(julianday(Date(end_date)) - julianday(start_date))+1 AS diff").where(id:lid)
  end

  def self.findAvAppManagement(eid,sid,did)
    find_by_sql ["SELECT department_id,name,leave_applications.employee_id AS eid,leave_applications.id AS lid,start_date,end_date,status_id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND status_id = 5 
      UNION 
      SELECT department_id,name,leave_applications.employee_id AS eid,leave_applications.id AS lid,start_date,end_date,status_id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND employee_id = ? AND (status_id = 1 OR status_id = 2 OR status_id = 3 OR status_id = 4) 
      UNION 
      SELECT department_id,name,leave_applications.employee_id AS eid,leave_applications.id AS lid,start_date,end_date,status_id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND  status_id = ? AND department_id = ? ",eid,sid,did]
  end

  def self.findAvApp(id)
    find_by_sql ["SELECT department_id,name,leave_applications.employee_id AS eid,leave_applications.id AS lid,start_date,end_date,status_id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND status_id = 5 
      UNION 
      SELECT department_id,name,leave_applications.employee_id AS eid,leave_applications.id AS lid,start_date,end_date,status_id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND employee_id = ? AND (status_id = 1 OR status_id = 2 OR status_id = 3 OR status_id = 4)",id]
  end

  def self.findAv(id,date)
    find_by_sql ["SELECT id FROM leave_applications WHERE employee_id = ? AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))",id,date,date]
  end

  def self.myDepartment(employee)
  	select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(employee_id:employee)
  end

  def self.findByDepartment(dept,status)
    select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(:employees => {:department_id => dept},status_id:status)
  end

  def self.appDetails(application)
  	select("*,leave_applications.id,(julianday(end_date)-julianday(start_date))+1 AS date_diff").joins(:status,:leave).where(id:application)
  end 

  def self.myArchive(employee)
  	select('leave_applications.id,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where("employee_id = ? AND (status_id = 3 OR status_id = 5)",employee)
  end

  def self.reportCount(emp_id,dept_id,month,year,s,e,sID)
    reports = LeaveApplication.joins(:employee => :department).where("status_id = ?",sID)
    reports = filter_report(reports,emp_id,dept_id,month,year,s,e) 
    reports 
  end

  def self.filter_report(reports,emp_id,dept_id,month,year,s,e)
     m = "0" + month unless month.to_i > 10 unless month.nil?
    reports = reports.where(employee_id:emp_id) unless emp_id == ''
    reports = reports.where(:departments => {id: dept_id}) unless dept_id == ''
    reports = reports.where("strftime('%m',start_date) = ?",m) unless month == ''
    reports = reports.where("strftime('%Y',start_date) = ?",year) unless year == ''
    reports = reports.where("strftime('%m/%d/%Y',start_date) >= ? AND strftime('%m/%d/%Y',start_date) <= ?",
      s,e) unless s == '' && e == ''
    reports.count
  end

end
