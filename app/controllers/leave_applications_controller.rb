class LeaveApplicationsController < ApplicationController
  
  def index
    @leaveApplications = LeaveApplication.leaveApproved
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show_status
    @leaveApplications = LeaveApplication.myDepartment(current_employee)
  end
def profile
    @leaveApplications = LeaveApplication.appProfile(current_employee)
   
end
  end
  def archive
    @leaveApplications = LeaveApplication.myArchive(current_employee)
  end

  def show
    @leaveApplication = LeaveApplication.appDetails(params[:id])  
    @review = LeaveApplication.find(params[:id])
  end

  def new
    @leaveApplication = LeaveApplication.new
  end

  def create
    @employee = Employee.find(current_employee)
    @leaveApplication = @employee.leave_applications.new(params[:leave_application])
    if @leaveApplication.save
      flash[:notice] = "Application has been successfully created!"
      redirect_to leave_applications_path
    else
      flash[:alert] = "Application failed to be created!"
      flash.discard
      render 'new'
    end
    
  end

  def edit
    @leaveApplication = LeaveApplication.find(params[:id])
  end

  def update
    
      @employee = Employee.find(current_employee)
      @leaveApplication = @employee.leave_applications.find(params[:id]).update_attributes(params[:leave_application])
       if @leaveApplication
         flash[:notice] = "Application has been successfully updated!"
          redirect_to leave_applications_path
      else
        flash[:alert] = "Application failed to be updated!"
        flash.discard
        render 'edit'
      end
  end

  def destroy
    @leaveApplication = LeaveApplication.find(params[:id])
    if @leaveApplication.destroy
      flash[:notice] = "Application has been successfully deleted!"
    else
      flash[:alert] = "Application failed to be deleted!"
    end
    redirect_to show_status_leave_applications_path
  end

  def report
    @employees = Employee.all
    @departments = Department.all
    nID = params[:emp_name]
    dID = params[:dept_name]

    if params[:month] 
      month = params[:month][:value]
    end

    if params[:year]
      year = params[:year][:value]
    end
    
    if params[:rangeS] || params[:rangeE]
      s = params[:rangeS]
      e = params[:rangeE]
    end

  unless nID.nil? && dID.nil? && params[:month].nil? && params[:year].nil? && params[:rangeS].nil? && params[:rangeE].nil?
    @reportsA = LeaveApplication.reportCount(nID,dID,month,year,s,e,5)
    @reportsR = LeaveApplication.reportCount(nID,dID,month,year,s,e,3)
    end  
  end

  def pdfGen
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(params[:approve],params[:reject])
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def management
    if current_employee.role_id == 2 || current_employee.role_id == 5
      @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,2)
    elsif current_employee.role_id == 3 
       @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,4)
    end
  end

  def updateReview
    @review = LeaveApplication.find(params[:id])
    @emp = Employee.find(@review.employee_id)
    if @review.update_attributes(status_id: params[:leave_application][:status])
          
          if current_employee.role_id == 4
            if @review.status_id == 5
              newBal = @emp.leave_balance - 1
              @emp.update_attributes(leave_balance: newBal)
            end
          end
            
        flash[:notice] = "Successfully Updated Status"
    else
      flash[:alert] = "Failed to Update Status"
    end
    flash.discard
    redirect_to management_leave_applications_path
  end
  
end
