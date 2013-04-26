class Department < ActiveRecord::Base
  attr_accessible :department_name

  has_many :employees

end
