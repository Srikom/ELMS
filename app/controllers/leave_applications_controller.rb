class LeaveApplicationsController < ApplicationController
  
  def index
    @leaveApplications = LeaveApplication.leaveApproved
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show_status
    @leaveApplications = LeaveApplication.myDepartment(current_employee)
  end

  def archive
    @leaveApplications = LeaveApplication.myArchive(current_employee)
  end

  def show
    @leaveApplication = LeaveApplication.appDetails(params[:id])  
  end

  def new
    @leaveApplication = LeaveApplication.new
  end

  def create
    @employee = Employee.find(current_employee)
    @leaveApplication = @employee.leave_applications.new(start_date:params[:leave_application][:start_date],
      end_date:params[:leave_application][:end_date],
      leave_id:params[:leave_application][:leave_id],reason:params[:leave_application][:reason])
    if @leaveApplication.save!
      flash[:notice] = "Application has been successfully created!"
    else
      flash[:alert] = "Application failed to be created!"
    end
    redirect_to leave_applications_path
  end

  

  def edit

  end

  def update

  end

  def destroy

  end
  
end
