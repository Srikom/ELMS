class EmployeesController < ApplicationController

  def index
    @employees = Employee.all
  end
def profile
    @employees = Employee.appProfile(current_employee)
    
end
  end
  def destroy
    @employees = Employee.find(params[:id])
    @employees.destroy 

    flash[:notice] = "User has been deleted"
    redirect_to employees_path
  end

  def show
    @employees = Employee.find(params[:id])
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  
end
