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
    if params[:leave_application][:leave_id] != "0"
      @employee = Employee.find(current_employee)
      @leaveApplication = @employee.leave_applications.find(params[:id]).update_attributes(params[:leave_application])
       if @leaveApplication
         flash[:notice] = "Application has been successfully updated!"
          redirect_to leave_applications_path
      else
        flash[:alert] = "Application failed to be updated!"
        flash.discard
        redirect_to :action => :edit
      end
    else
      redirect_to :action => :edit,:alert => "PLease select a leave type!"
    end
  end

  def destroy

  end
  
end
