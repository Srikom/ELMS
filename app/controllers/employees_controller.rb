class EmployeesController < ApplicationController

  def index
    @search = Employee.search(params[:q])
    @employees = @search.result(:distinct => true)
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
    @departments = Department.all
    @roles = Role.all
    @employees = Employee.new
  end

  def create
    @employees = Employee.new(params[:employee])
    if @employees.save
      flash[:notice] = "Successfully created User!"
      redirect_to employees_path
    else
      flash[:alert] = "Error creating the User!"
      render 'new'
    end
  end

  def edit

  end

  def update

  end

  
end
