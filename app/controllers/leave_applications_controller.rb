class LeaveApplicationsController < ApplicationController
  
  def index
    @leaveApplications = LeaveApplication.myDepartment(current_employee)
  end

  def new

  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end
  
end
