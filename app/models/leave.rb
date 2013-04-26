class Leave < ActiveRecord::Base
  attr_accessible :leave_name

  has_many :leave_applications
end
