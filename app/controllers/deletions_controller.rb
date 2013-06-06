class DeletionsController < ApplicationController

    def index
        if current_employee.role_id == 2 || current_employee.role_id == 3 || current_employee.role_id == 5
            @del = Deletion.paginate(:page => params[:page], :per_page => 5, :order => "created_at DESC")
        else
          flash[:alert] = "You are not allowed to access this page!"
          redirect_to leave_applications_path
        end
    end

	def create
		@emp = Employee.find(params[:deletion][:eid])
		@leaveApplication = LeaveApplication.find(params[:deletion][:lid])
    sid = @leaveApplication.status_id
    	@del = Deletion.new
      @res = false
    	
    	@del.leave_application_id = params[:deletion][:lid] 
    	@del.employee_id = params[:deletion][:eid]
    	@del.start_date = params[:deletion][:sDate] 
    	@del.end_date = params[:deletion][:eDate] 
    	@del.reason = params[:deletion][:reason]
    	
    if @del.save!
      if @leaveApplication.destroy

        if sid == 5
          lb = @emp.leave_balance.to_i
          lb2 = @emp.leave_bal.to_i
          diff = params[:deletion][:bal].to_i
          @date_bal = (lb + diff)
          @date_bal2 = (lb2 + diff)
         @emp.update_attributes(leave_balance: @date_bal,leave_bal: @date_bal2)
        end

        @res = true
        flash[:alert] = "Application has been deleted!"
       else
      	  flash[:alert] = "Application failed to be deleted!"
       end
    else
    	flash[:alert] = "Failed to create data!"
    end

    respond_to do |format|
      format.html {redirect_to show_status_leave_applications_path}
      format.js {flash.discard}
    end

	end

end
