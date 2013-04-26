class LeaveApplication < ActiveRecord::Base
  attr_accessible :end_date, :leave_id, :reason, :start_date, :status_id

  validates :end_date, :start_date, :leave_id, :reason, presence: true

end
