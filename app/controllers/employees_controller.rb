class EmployeesController < ApplicationController

  def index
    @employees = Employee.all
  end

  def destroy
    @employees = Employee.find(params[:id])
    @employees.destroy 

    flash[:notice] = "User has been deleted"
    redirect_to employees_path
  end

  def show
    @show = Employee.select("*").joins(:department).where(id:params[:id])
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
