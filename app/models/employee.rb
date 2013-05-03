class Employee < ActiveRecord::Base
 
  devise :database_authenticatable,:recoverable, :rememberable, :trackable, :validatable

 
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone, :role_id,:department_id,:leave_balance
  

  validates :name, :phone, :role_id,:department_id, presence: true

  belongs_to :role
  belongs_to :department
  has_many :leave_applications
 
end
