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
     leaveApplication = LeaveApplication.appDetails(lid)
     review = LeaveApplication.find(lid)
      @del = Deletion.new
     render :partial => 'details', locals: {lid: lid, eid: eid, sid: sid, did: did, sd: sd, ed: ed,date: dt,leaveApplication: leaveApplication, review: review}
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
          diff = ((@ed - @sd) + 1)
          bal = @employee.leave_bal - diff.to_i
          checkAvailable = LeaveApplication.checkDateApp(current_employee,@sd,@ed)

          if checkAvailable.empty?
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
                      @ld = @leaveApplication
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
            checkAvailable = LeaveApplication.checkDateApp(current_employee,@sd,@ed)
            @employee = Employee.find(current_employee)
            @ld = @employee.leave_applications.find(params[:id])
            @sd = @ld.start_date
            @ed = @ld.end_date
            @sd2 = params[:leave_application][:start_date]
            @ed2 = params[:leave_application][:end_date]
          if checkAvailable.empty? || ((@sd == @sd2) && (@ed == @ed2))
            
            @leaveApplication = @employee.leave_applications.find(params[:id]).update_attributes(params[:leave_application])
           
              if params[:submit] && (current_employee.role_id == 1 || current_employee.role_id == 2 || current_employee.role_id == 4 || current_employee.role_id == 5)
                   @ld.status_id = 2 
              elsif params[:submit] && current_employee.role_id == 3
                    @ld.status_id = 4
              end
              
               if @leaveApplication && @ld.save
                 flash[:notice] = "Application has been successfully updated!"

                  @ld = LeaveApplication.find(params[:id])
                   @sd = Date.parse(@ld.start_date.strftime("%Y-%m-%d"))
                  @ed = Date.parse(@ld.end_date.strftime("%Y-%m-%d"))
                  @date = params[:leave_application][:start_date]
                 @updated = true
              else
                flash[:alert] = "Application failed to be updated!"
                flash.discard
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
    @bal = LeaveApplication.dateDiff(params[:id])
    @bal.each do |d|
      @diff = d.diff
    end
    newBal = @employee.leave_bal + @diff
    newBal2 = @employee.leave_balance + @diff

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
            @approve = Array.new
            @reject = Array.new
              if @reports.empty?
                flash[:alert] = "No data found!"
                flash.discard
              end
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

    @update = false
    @did = params[:leave_application][:did]
    @dt = params[:leave_application][:date]
    @sd = @review.start_date
    @ed = @review.end_date

      @bal = LeaveApplication.dateDiff(params[:id])
      @bal.each do |d|
       @diff = d.diff
      end
      @lBal = @emp.leave_bal + @diff.to_i
      
    lb = @emp.leave_balance.to_i
    diff = params[:leave_application][:bal].to_i
    date_bal = (lb - diff)
    if @review.update_attributes(status_id: params[:leave_application][:status])
          if current_employee.role_id == 3
            if @review.status_id == 5
              @emp.update_attributes(leave_balance: date_bal)
            end
          end
          if @review.status_id == 3
              @emp.update_attributes(leave_bal: @lBal)
          end
        @update = true
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

end
