class Employee < ActiveRecord::Base
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone, :role_id,:department_id
  

  validates :name, :phone, :role_id,:department_id, presence: true

  belongs_to :role
  belongs_to :department
  has_many :leave_applications
end
