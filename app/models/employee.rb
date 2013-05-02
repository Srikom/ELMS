class Employee < ActiveRecord::Base
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone, :role_id,:department_id,:leave_balance
  

  validates :name, :phone, :role_id,:department_id, presence: true

  belongs_to :role
  belongs_to :department
  has_many :leave_applications
  def self.appProfile(employee)
  	
  # @employees = Employee.select("*,department_name,name,id,email,phone").joins(:employee,:department)
   @employees= Employee.find_by_sql(%q{SELECT id,email,name,phone FROM employees WHERE id="1"} )
end
end
