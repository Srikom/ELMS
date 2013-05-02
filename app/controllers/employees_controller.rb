class EmployeesController < ApplicationController

  def index
    @employees = Employee.select("*").joins(:department , :role)
  end

  def destroy
    @employees = Employee.find(params[:id])
    @employees.destroy 

    flash[:notice] = "User has been deleted"
    redirect_to employees_path
  end

  def show
    @show = Employee.select("*").joins(:department , :role).where(id:params[:id])
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
