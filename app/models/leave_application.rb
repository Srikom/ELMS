class LeaveApplication < ActiveRecord::Base
  attr_accessible :end_date, :leave_id, :reason, :start_date, :status_id, :employee_id, :leave, :date

  validates :end_date, :start_date, :leave_id, :reason, :employee_id, :status_id, presence: true

  belongs_to :status
  belongs_to :leave
  belongs_to :employee


  def self.checkDateApp(eid,sd,ed)
    find_by_sql ["SELECT id FROM leave_applications WHERE employee_id = ? AND ((start_date between ? AND ?) AND (end_date between ? AND ?))",eid,sd,ed,sd,ed]
  end

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

  def self.findAv(eid,rid,did,date)
    if rid == 2 || rid == 5
      @leaveApplications = LeaveApplication.gatherByManage(eid,2,did,date)
    elsif rid == 3
      @leaveApplications = LeaveApplication.gatherByManage(eid,4,did,date)
    elsif rid == 4 || rid == 1
      @leaveApplications = LeaveApplication.gatherByStaff(eid,date)
    end
  end

  def self.gatherByManage(eid,sid,did,date)
     find_by_sql ["SELECT leave_applications.id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date)) AND status_id = 5 
      UNION 
      SELECT leave_applications.id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND employee_id = ? AND (status_id = 1 OR status_id = 2 OR status_id = 3 OR status_id = 4) AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))
      UNION 
      SELECT leave_applications.id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND  status_id = ? AND department_id = ? AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))",date,date,eid,date,date,sid,did,date,date]
  end

  def self.gatherByStaff(eid,date)
       find_by_sql ["SELECT leave_applications.id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND status_id = 5 AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))
      UNION 
      SELECT leave_applications.id FROM leave_applications,employees WHERE leave_applications.employee_id = employees.id AND employee_id = ? AND (status_id = 1 OR status_id = 2 OR status_id = 3 OR status_id = 4) AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))",date,date,eid,date,date]
  end

  def self.checkDateAv(eid,date)
      select("id").where("employee_id = ? AND (strftime('%Y-%m-%d',start_date) <= ? AND ? <= strftime('%Y-%m-%d',end_date))",eid,date,date)
  end

  def self.myDepartment(employee)
    select('leave_applications.id,employees.name,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(employee_id:employee)
  end

  def self.findByDepartment(dept,status)
    select('leave_applications.id,employees.name,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where(:employees => {:department_id => dept},status_id:status).order("leave_applications.updated_at DESC")
  end

  def self.appDetails(application)
    select("*,leave_applications.id,(julianday(end_date)-julianday(start_date))+1 AS date_diff").joins(:status,:leave).where(id:application)
  end 

  def self.myArchive(employee)
    select('leave_applications.id,employees.name,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where("employee_id = ? AND (status_id = 3 OR status_id = 5)",employee)
  end

  def self.myStatus(employee)
    select('leave_applications.id,employees.name,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where("employee_id = ? AND leave_applications.created_at > ?",employee,1.month.ago).order("leave_applications.updated_at DESC")
  end

  def self.reportCount(emp_id,dept_id,s,e)
    reports = LeaveApplication.select("start_date AS MONTH,strftime('%Y',start_date) AS YEAR,employees.name AS NAME, departments.department_name AS DEPARTMENT ,SUM(CASE leave_applications.status_id WHEN 3 THEN 1 ELSE 0 END) AS REJECTED,  
SUM(CASE leave_applications.status_id WHEN 5 THEN 1 ELSE 0 END) AS APPROVED").joins(:employee => :department).where("status_id = 3 OR status_id = 5")
    reports = filter_report(reports,emp_id,dept_id,s,e) 
    reports.group("strftime('%m',start_date),employees.name")
  end



  def self.filter_report(reports,emp_id,dept_id,s,e)
    reports = reports.where(employee_id:emp_id) unless emp_id == ''
    reports = reports.where(:departments => {id: dept_id}) unless dept_id == ''
    reports = reports.where("strftime('%m/%d/%Y',start_date) >= ? AND strftime('%m/%d/%Y',start_date) <= ?",
      s,e) unless s == '' && e == ''
    reports
  end

  def self.filterArchive(status,employee)
    select('leave_applications.id,employees.name,department_name,leave_applications.created_at,status_name').joins({:employee => :department}, :status).where("status_id = ? AND employee_id = ? " ,status,employee)
  end

end
