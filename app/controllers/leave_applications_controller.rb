class LeaveApplicationsController < ApplicationController
  
  def index
    
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

  end

  def create

  end

  

  def edit

  end

  def update

  end

  def destroy

  end
  
end
