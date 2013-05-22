class LeaveApplicationsController < ApplicationController
  
  

  def index
    if current_employee.role_id == 2 || current_employee.role_id == 5
      @leaveApplications = LeaveApplication.findAvAppManagement(current_employee,2,current_employee.department_id)
    elsif current_employee.role_id == 3
      @leaveApplications = LeaveApplication.findAvAppManagement(current_employee,4,current_employee.department_id)
    elsif current_employee.role_id == 4 || current_employee.role_id == 1
      @leaveApplications = LeaveApplication.findAvApp(current_employee)
    end
    @del = Deletion.new
    

    if params[:month] 
      month = params[:month][:value]
      if month == ""
        month = Date.today.strftime('%m')
      end
    end

    if params[:year]
      year = params[:year][:value]
      if year == ""
        year = Date.today.strftime('%Y')
      end
    end

    if year && month
      day = Date.today.strftime('%d')
      params[:date] = "#{year}-#{month}-#{day}"
    elsif year
      day = Date.today.strftime('%d')
      month = Date.today.strftime('%m')
      params[:date] = "#{year}-#{month}-#{day}"
    elsif month
      day = Date.today.strftime('%d')
      year = Date.today.strftime('%Y')
      params[:date] = "#{year}-#{month}-#{day}"
    end

    @date = params[:date] ? Date.parse(params[:date]) : Date.today

  end

  def show_status

    @statuses = Status.all
    sID = params[:status_name]

    if sID.to_i == 1 
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID.to_i == 2
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID.to_i == 3
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID.to_i == 4
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID.to_i == 5
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID == ""
     @leaveApplications = LeaveApplication.myArchive(current_employee).paginate(:page => params[:page], :per_page => 5)
    end

    @leaveApplications = params[:status_name] ? @leaveApplications : LeaveApplication.myArchive(current_employee).paginate(:page => params[:page], :per_page => 5)
  

  end

  def archive
    

    @statuses = Status.all
    sID = params[:status_name]

    if sID.to_i == 5 
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee)
    elsif sID.to_i == 2
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee)
    elsif sID == ""
     @leaveApplications = LeaveApplication.myArchive(current_employee)
    end

     @leaveApplications = params[:status_name] ? @leaveApplications : LeaveApplication.myArchive(current_employee)

     @pages = LeaveApplication.page(params[:page]).per(5)
  end

  def show
    @leaveApplication = LeaveApplication.appDetails(params[:id])  
    @review = LeaveApplication.find(params[:id])
  end

  def new
    @leaveApplication = LeaveApplication.new
    @date = params[:date]
  end

  def create
    @employee = Employee.find(current_employee)
    sd = Date.parse(params[:leave_application][:start_date])
    ed = Date.parse(params[:leave_application][:end_date])
    dt = Date.today
    diff = ((ed - sd) + 1)
    bal = @employee.leave_bal - diff.to_i

    if sd > ed || ((sd <= dt) && (sd >= ed))
       flash[:alert] = "The end date cannot be the past date!"
       redirect_to new_leave_application_path
    else
        if bal > 0
          @leaveApplication = @employee.leave_applications.new(params[:leave_application])

          if params[:submit] && (current_employee.role_id == 1 || current_employee.role_id == 2)
             @leaveApplication.status_id = 2 
          elsif params[:submit] && current_employee.role_id == 3
              @leaveApplication.update_attributes(status_id: 4)
          end

          if @leaveApplication.save && @employee.update_attributes(leave_bal: bal)
              flash[:notice] = "Application has been successfully created!"
              redirect_to leave_applications_path
          else
            flash[:alert] = "Application failed to be created!"
            redirect_to new_leave_application_path
          end
        else
            flash[:alert] = "Cannot apply for leave due to unsufficient leave balance!"
            redirect_to new_leave_application_path
        end
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
    @employee = Employee.find(@leaveApplication.employee_id)
    @res = false
    @bal = LeaveApplication.dateDiff(params[:id])

    @bal.each do |d|
      @diff = d.diff
    end
    newBal = @employee.leave_bal + @diff

    if @leaveApplication.status_id == 5
      if @leaveApplication.destroy && @employee.update_attributes(leave_bal: newBal, leave_balance: newBal)
        @res = true
      end 
    else
      if @leaveApplication.destroy && @employee.update_attributes(leave_bal: newBal)
        @res = true
      end 
    end

    if @res == true
      flash[:notice] = "Application has been successfully deleted!"
    else
      flash[:alert] = "Application failed to be deleted!"
    end
    redirect_to leave_applications_path
  end

  def report
    if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
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

         if (nID == "" && dID == "" && month == "" && year == "" && s == "" && e == "") 
            flash[:alert] = "Enter atleast one particular field!"
            flash.discard
        else
          unless (nID.nil? || nID == "") && (dID.nil? || dID == "") && (params[:month].nil? || params[:month] == "") && (params[:year].nil? || params[:year] == "" ) && (params[:rangeS].nil? || params[:rangeS] == "") && (params[:rangeE].nil? || params[:rangeE] == "") 
            @reportsA = LeaveApplication.reportCount(nID,dID,month,year,s,e,5)
            @reportsR = LeaveApplication.reportCount(nID,dID,month,year,s,e,3)
              if @reportsA == 0 && @reportsR == 0
                flash[:alert] = "No data found!"
                flash.discard
              end
            end  
        end
    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
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

  if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
    if current_employee.role_id == 2 || current_employee.role_id == 5
      @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,2)
    elsif current_employee.role_id == 3 
       @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,4)
    end
   else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end

    @pages = LeaveApplication.page(params[:page]).per(5)

  end

  def updateReview
    @review = LeaveApplication.find(params[:id])
    @emp = Employee.find(@review.employee_id)
    lb = @emp.leave_balance.to_i
    diff = params[:leave_application][:bal].to_i
    date_bal = (lb - diff)
    if @review.update_attributes(status_id: params[:leave_application][:status])
          if current_employee.role_id == 3
            if @review.status_id == 5
              @emp.update_attributes(leave_balance: date_bal)
            elsif @review.status_id == 3
              lbal = @emp.leave_bal + diff
              @emp.update_attributes(leave_bal: lbal)
            end
          end
        flash[:notice] = "Successfully Updated Status"
    else
      flash[:alert] = "Failed to Update Status"
    end
    redirect_to leave_applications_path
  end
  

  def submitApp
    @leaveApplication = LeaveApplication.find(params[:id])
    if current_employee.role_id == 3
      if @leaveApplication.update_attributes(status_id: 4)
        flash[:notice] = "Successfully Submit form!"
      else
        flash[:notice] = "Form failed to be submitted!"
      end
    else
      if @leaveApplication.update_attributes(status_id: 2)
        flash[:notice] = "Successfully Submit form!"
      else
        flash[:notice] = "Form failed to be submitted!"
      end
    end
    redirect_to leave_applications_path
  end

 

end
