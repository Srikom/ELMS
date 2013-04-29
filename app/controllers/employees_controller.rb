class EmployeesController < ApplicationController

  def index
    @employees = Employee.all
  end

  def new

  end

  def create

  end

  def show
    @employees = Employee.find(params[:id])
  end

  def edit

  end

  def update

  end

  def destroy
    @employees = Employee.find(params[:id])
    @employees.destroy 

    flash[:notice] = "User has been deleted"
    redirect_to employees_index_path
  end
  
end
