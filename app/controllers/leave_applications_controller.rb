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
    if params[:edit_profile] == "Edit profile"
render 'edit'
end
if params[:commit] == "Edit password"
render 'edit'
end
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


    if params[:emp_name] && params[:dept_name] && params[:rangeS] && params[:rangeE]
      @la = 45
    end
    if params[:emp_name]
      @la = 45
    end
    if params[:dept_name]
      @la = 45
    end
     if params[:emp_name] && params[:dept_name]
      @la = 45
    end
    elseif params[:rangeS]
      @la = params[:rangeS].map{|k,v| v}.join("-").to_date
      @la = @la.strftime('%d %B %Y')
    elseif params[:rangeE]
      @la = params[:rangeE]
    end

    #@report = LeaveApplication.filterLeaveApp(params[:name],params[:department],params[:month],
      #params[:year],params[:rangeS],params[:rangeE])
  end

  def management
    
  end

  def updateReview
    @review = LeaveApplication.find(params[:id])
    if @review.update_attributes(status: params[:leave_application][:status])
        flash[:notice] = "Successfully Updated Status"
    else
      flash[:alert] = "Failed to Update Status"
    end
    flash.discard
    redirect_to management_leave_application_path
  end
  

