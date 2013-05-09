class AddColumnEmpIdToDeletions < ActiveRecord::Migration
  def up
  	add_column :deletions,:employee_id,:integer
  end
end
