class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
  		stored_location_for(resource) ||
    		if resource.is_a?(Employee)
      			leave_applications_path
    		end
  end

  def after_sign_out_path_for(resource_or_scope)
  	new_employee_session_path          
  end

  def after_sign_up_path_for(resource)
    employees_path
  end


end
