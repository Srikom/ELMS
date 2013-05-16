class RolesController < ApplicationController

	def index
		if current_employee.role_id == 4 || current_employee.role_id == 5
			@roles = Role.all
		end
	end

	def new
		if current_employee.role_id == 4 || current_employee.role_id == 5
			@role = Role.new
		end
	end

	def create 

	end

	def edit 

	end

	def update

	end

end
