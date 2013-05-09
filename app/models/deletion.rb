class Deletion < ActiveRecord::Base
  attr_accessible :leave_application_id, :employee_id,:reason, :start_date, :end_date

  validates :leave_application_id, :employee_id,:reason, :start_date, :end_date, presence: true

  def self.findDel(eid)
  	where(employee_id: eid)
  end

end
