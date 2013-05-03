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
    @employees = Employee.new
  end

  def create
    @employees = Employee.new(params[:employee])

    if @employees.save
      flash[:notice] = "Successfully created User!"
      redirect_to employees_path
    else
      redirect_to employees_new_path
    end
  end

  def edit

  end

  def update

  end

  
end
