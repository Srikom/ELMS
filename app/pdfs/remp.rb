class Remp < Prawn::Document

	def initialize(reports,sum_days)
		super(top_margin:70)
		@reports = reports
		@sum_days = sum_days
		report_name
		table_data
		footer_sig
	end

	def report_name
		text "Total Amount of Leave Application Taken By Employee", size:30 , style: :bold,:align => :center
		move_down 5
		text "as on #{Date.today.strftime('%d %B %Y')}",style: :bold,:align => :center
		move_down 20
		text "Total number of application's : #{@sum_days}"
		move_down 10
	end

	def table_data
		text "List of Application's: "
		move_down 10
		table datas do
			row(0).font_style = :bold
			columns(0..4).align = :right
			self.row_colors = ["DDDDDD","FFFFFF"]
			self.header = true
		end
		move_down 30
	end

	def datas
		app = [["Start Date","End Date","Employee Name","Department","Number of Days"]] 
		app += @reports.map do |r|
		[(r.SD).to_date,(r.ED).to_date,r.NAME,r.DEPARTMENT,LeaveApplication.exclude_weekends((r.SD).to_date,(r.ED).to_date)]
		end
		app += [[{:content => "Total Days",:colspan => 4},"#{@sum_days}"]]
	end

	def footer_sig
		move_down 200
		text "Submitted BY:",style: :bold,:align => :left
		move_up 15
		text "Signatures:",style: :bold,:align => :right
	end

end