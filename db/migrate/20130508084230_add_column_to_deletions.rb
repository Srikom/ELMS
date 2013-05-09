class AddColumnToDeletions < ActiveRecord::Migration
  def up
  	add_column :deletions,:start_date,:date
  	add_column :deletions,:end_date,:date
  end
end
