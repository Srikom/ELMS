class EmployeesController < ApplicationController

 

  def index
    if current_employee.role_id == 4 || current_employee.role_id == 5
      @employees = Employee.all
    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end

  def destroy
    @employees = Employee.find(params[:id])
    @employees.destroy 

    flash[:notice] = "User has been deleted"
    redirect_to employees_path
  end

  def show
    @show = Employee.find(params[:id])
  end

  def new
    if current_employee.role_id == 4 || current_employee.role_id == 5
      @departments = Department.all
      @roles = Role.all
      @employees = Employee.new
    else
      flash[:alert] = "You are not allowed to access this page!"
      redirect_to leave_applications_path
    end
  end

  def create
    @employees = Employee.new(params[:employee])
    @curr_emp = Employee.find(current_employee)
    if @employees.save
      flash[:notice] = "Successfully created User!"
      sign_in @curr_emp, :bypass => true
      redirect_to employees_path
    else
      flash[:alert] = "Error creating the User!"
      render 'new'
    end
  end

  def edit
    @employees = Employee.find(params[:id])
  end

  def update
    @employees = Employee.find(params[:id])

  if @employees.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated User details!"
      sign_in @employees, :bypass => true
      redirect_to employee_path(params[:id])
    else
      flash[:alert] = "Error creating updating the User details!"
      render 'edit'
    end
  end

end
