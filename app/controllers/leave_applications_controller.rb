class LeaveApplicationsController < ApplicationController
  
  

  def index
    if current_employee.role_id == 2 || current_employee.role_id == 5
      @leaveApplications = LeaveApplication.findAvAppManagement(current_employee,2,current_employee.department_id)
    elsif current_employee.role_id == 3
      @leaveApplications = LeaveApplication.findAvAppManagement(current_employee,4,current_employee.department_id)
    elsif current_employee.role_id == 4 || current_employee.role_id == 1
      @leaveApplications = LeaveApplication.findAvApp(current_employee)
    end
  
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

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show_status
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
     @leaveApplications = LeaveApplication.myStatus(current_employee).paginate(:page => params[:page], :per_page => 5)
    end

    @leaveApplications = params[:status_name] ? @leaveApplications : LeaveApplication.myStatus(current_employee).paginate(:page => params[:page], :per_page => 5)
  
  end

  def showDetails
     lid = params[:lid].to_i
     eid = params[:eid].to_i
     sid = params[:sid].to_i
     did = params[:did].to_i
     sd = Date.parse(params[:sd])
     ed = Date.parse(params[:ed])
     dt = Date.parse(params[:dt])
     @leaveApplication = LeaveApplication.appDetails(lid)
     review = LeaveApplication.find(lid)
      @del = Deletion.new
     render :partial => 'details', locals: {lid: lid, eid: eid, sid: sid, did: did, sd: sd, ed: ed,date: dt, review: review}
  end

  def archive
    sID = params[:status_name]

    if sID.to_i == 5 
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID.to_i == 3
      @leaveApplications = LeaveApplication.filterArchive(sID,current_employee).paginate(:page => params[:page], :per_page => 5)
    elsif sID == ""
     @leaveApplications = LeaveApplication.myArchive(current_employee).paginate(:page => params[:page], :per_page => 5)
    end

     @leaveApplications = params[:status_name] ? @leaveApplications : LeaveApplication.myArchive(current_employee).paginate(:page => params[:page], :per_page => 5)
 
  end

  def new 
    @leaveApplication = LeaveApplication.new
    @date = params[:dt]
    @edate = @date
    render :partial => "form"
  end

  def show
    @leaveApplication = LeaveApplication.appDetails(params[:id])  
    @ld = LeaveApplication.find(params[:id])
    @emp = Employee.find(@ld.employee_id)
    @del = Deletion.new
  end

  def create
    @employee = Employee.find(current_employee)
    @created = false

    if params[:leave_application][:start_date] != "" && params[:leave_application][:end_date] != ""
          @sd = Date.parse(params[:leave_application][:start_date])
          @ed = Date.parse(params[:leave_application][:end_date])
          dt = Date.today

          @actual_days = LeaveApplication.exclude_weekends(@sd,@ed)
          diff = @actual_days
          bal = @employee.leave_bal - diff.to_i

          overlap = LeaveApplication.overlaps(current_employee,@sd,@ed)

          if (overlap == 0)
            if @sd > @ed || ((@sd <= dt) && (@sd >= @ed))
               flash[:alert] = "The end date cannot be the past date!"
            else
                if bal > 0
                  @leaveApplication = @employee.leave_applications.new(params[:leave_application])

                  if params[:submit] && (current_employee.role_id == 1 || current_employee.role_id == 2 || current_employee.role_id == 4 || current_employee.role_id == 5)
                     @leaveApplication.status_id = 2 
                  elsif params[:submit] && current_employee.role_id == 3
                      @leaveApplication.status_id = 4
                  end

                  if @leaveApplication.save && @employee.update_attributes(leave_bal: bal)
                      @created = true 
                      flash[:notice] = "Application has been successfully created!"
                  end
                else
                    flash[:alert] = "Cannot apply for leave due to unsufficient leave balance!"
                end
            end 
        else
           flash[:alert] = "Application on this date exists!" 
        end
    end

    respond_to do |format|
      format.html {redirect_to leave_applications_path}
      format.js {flash.discard}
    end

  end

  def edit
    @leaveApplication = LeaveApplication.find(params[:id])
    @sd = @leaveApplication.start_date.strftime("%Y-%m-%d")
    @ed = @leaveApplication.end_date.strftime("%Y-%m-%d")
    respond_to do |format|
      format.html 
      format.js 
    end
  end

  def update
            @updated = false
            @employee = Employee.find(current_employee)
            @ld = LeaveApplication.find(params[:id])
            @sd = @ld.start_date
            @ed = @ld.end_date
            @sd2 = Date.parse(params[:leave_application][:start_date])
            @ed2 = Date.parse(params[:leave_application][:end_date])

            @overlap = LeaveApplication.overlaps(current_employee,@sd2,@ed2)

            if (@overlap == 0) || ((@sd == @sd2) || (@ed == @ed2))
                @ad = LeaveApplication.exclude_weekends(@sd,@ed)
                @fd = @employee.leave_bal + @ad
                @actual_days = LeaveApplication.exclude_weekends(@sd2,@ed2)
                @bal = @fd - @actual_days.to_i
              
              @leaveApplication = @employee.leave_applications.find(params[:id]).update_attributes(params[:leave_application])
             
                if params[:submit] && (current_employee.role_id == 1 || current_employee.role_id == 2 || current_employee.role_id == 4 || current_employee.role_id == 5)
                     @ld.status_id = 2 
                elsif params[:submit] && current_employee.role_id == 3
                      @ld.status_id = 4
                end
                
                 if @leaveApplication && @ld.save && @employee.update_attributes(leave_bal: @bal)
                   flash[:notice] = "Application has been successfully updated!"
                    @date = Date.parse(params[:leave_application][:start_date])
                   @updated = true
                else
                  flash[:alert] = "Application failed to be updated!"
                  render 'edit'
                end
             else
           flash[:alert] = "Application on this date exists!" 
        end

      respond_to do |format|
      format.html {redirect_to leave_application_path(params[:id])}
      format.js {flash.discard}
    end
  end

  def destroy
    @leaveApplication = LeaveApplication.find(params[:id])
    @employee = Employee.find(@leaveApplication.employee_id)
    @res = false
    diff = LeaveApplication.exclude_weekends(@leaveApplication.start_date,@leaveApplication.end_date)
    newBal = @employee.leave_bal + diff
    newBal2 = @employee.leave_balance + diff

    if @leaveApplication.status_id == 5
      if @leaveApplication.destroy && @employee.update_attributes(leave_bal: newBal, leave_balance: newBal2)
        @res = true
      end 
    else
      if @leaveApplication.destroy && @employee.update_attributes(leave_bal: newBal)
        @res = true
      end 
    end

    if @res == true
      @date = @leaveApplication.start_date.to_date
      flash[:notice] = "Application has been successfully deleted!"
    else
      flash[:alert] = "Application failed to be deleted!"
    end
    
    respond_to do |format|
      format.html {redirect_to show_status_leave_applications_path}
      format.js {flash.discard}
    end

  end

  def report
    if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
        @employees = Employee.all
        @departments = Department.all
        nID = params[:emp_name]
        dID = params[:dept_name]
        @response = false 

        if params[:rangeS] || params[:rangeE] 
          s = params[:rangeS]
          e = params[:rangeE]
        end
          
          unless  nID.nil? && dID.nil? && s.nil? && e.nil?
            @reports = LeaveApplication.reportCount(nID,dID,s,e)
            @nID = nID
            @dID = dID
            @s = s
            @e = e
            @approveM = Array.new
            @pending = Array.new
            @approve = Array.new
            @reject = Array.new
            @response = true
              if @reports.empty?
                flash[:alert] = "No data found!"
                @response = false 
              end
          end

        respond_to do |format|
            format.html
            format.js{flash.discard}
        end
    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end

  def pdfGen
    @r = LeaveApplication.reportCount(params[:nID],params[:dID],params[:s],params[:e])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@r,params[:a],params[:r])
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def management
  if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
    if current_employee.role_id == 2 || current_employee.role_id == 5
      @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,2).paginate(:page => params[:page], :per_page => 5)
    elsif current_employee.role_id == 3 
       @leaveApplications = LeaveApplication.findByDepartment(current_employee.department_id,4).paginate(:page => params[:page], :per_page => 5)
    end
   else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end

  def updateReview
    @review = LeaveApplication.find(params[:id])
    @emp = Employee.find(@review.employee_id)

    @sd = @review.start_date
    @ed = @review.end_date
    
    @update = false

    ad = LeaveApplication.exclude_weekends(@sd,@ed)
      
    if @review.update_attributes(status_id: params[:leave_application][:status])
          if current_employee.role_id == 3
            if @review.status_id == 5
              lb = @emp.leave_balance.to_i
              date_bal = (lb - ad)
              @emp.update_attributes(leave_balance: date_bal)
            end
          end
          if @review.status_id == 3
              lBal = @emp.leave_bal + ad
              @emp.update_attributes(leave_bal: lBal)
          end
        @update = true
        @date = @review.start_date.to_date
        flash[:notice] = "Successfully Updated Status"
    else
      flash[:alert] = "Failed to Update Status"
    end

    respond_to do |format|
      format.html {redirect_to leave_application_path(params[:id])}
      format.js {flash.discard}
    end

  end
  

  def submitApp
    @leaveApplication = LeaveApplication.find(params[:id])
    @submission = false
   
    @did = params[:submission][:did]
    @dt = params[:submission][:date]
    @sd = @leaveApplication.start_date
    @ed = @leaveApplication.end_date

    if current_employee.role_id == 3
      if @leaveApplication.update_attributes(status_id: 4)
        flash[:notice] = "Successfully Submit form!"
        @submission = true
      else
        flash[:notice] = "Form failed to be submitted!"
      end
    else
      if @leaveApplication.update_attributes(status_id: 2)
        flash[:notice] = "Successfully Submit form!"
        @submission = true
      else
        flash[:notice] = "Form failed to be submitted!"
      end
    end
    
    respond_to do |format|
      format.html {redirect_to leave_application_path(params[:id])}
      format.js {flash.discard}
    end
  end

  def pdfGenDept
    @r = LeaveApplication.reportCountDept(params[:dID],params[:s],params[:e])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Rdept.new(@r,params[:p],params[:am],params[:a],params[:r])
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end


  def reportDept
    if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
        @departments = Department.all
        dID = params[:dept_name]
        @response = false
        if params[:rangeS] || params[:rangeE] 
          s = params[:rangeS]
          e = params[:rangeE]
        end
          
          unless  dID.nil? && s.nil? && e.nil?
            @reports = LeaveApplication.reportCountDept(dID,s,e)
            @dID = dID
            @s = s
            @e = e
            @approveM = Array.new
            @pending = Array.new
            @approve = Array.new
            @reject = Array.new
            @response = true
              if @reports.empty?
                flash[:alert] = "No data found!"
                @response = false 
              end
          end
        respond_to do |format|
            format.html
            format.js{flash.discard}
        end
    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end

  def pdfGenEmp
    @r = LeaveApplication.reportCountEmp(params[:nID],params[:s],params[:e])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Remp.new(@r,params[:sum_days])
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end
  end


  def reportEmp
    if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
        @employees = Employee.all
        @departments = Department.all
        nID = params[:emp_name]
        @response = false

        if params[:rangeS] || params[:rangeE] 
          s = params[:rangeS]
          e = params[:rangeE]
        end
          
          unless  nID.nil? && s.nil? && e.nil?
            @reports = LeaveApplication.reportCountEmp(nID,s,e)
            @nID = nID
            @s = s
            @e = e
            @sum_days = Array.new
            @response = true
              if @reports.empty?
                flash[:alert] = "No data found!"
                @response = false 
              end
          end
          respond_to do |format|
            format.html
            format.js{flash.discard}
            end

    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end



end
