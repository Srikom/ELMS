class ReportPdf < Prawn::Document

	def initialize(reports,a,r)
		super(top_margin:70)
		@reports = reports
		@sum = a.to_i + r.to_i
		@approve = a
		@reject = r
		report_name
		table_data
		footer_sig
	end

	def report_name
		text "Total Leave Application", size:30 , style: :bold,:align => :center
		move_down 5
		text "as on #{Date.today.strftime('%d %B %Y')}",style: :bold,:align => :center
		move_down 20
		text "Total number of application's : #{@sum}"
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
		app = [["Year","Month","Employee Name","Department","Approved","Rejected"]] 
		app += @reports.map do |r|
		[r.YEAR,Date.parse(r.MONTH).strftime("%B"),r.NAME,r.DEPARTMENT,r.APPROVED,r.REJECTED]
		end
		app += [[{:content => "Total",:colspan => 4},"#{@approve}","#{@reject}"]]
	end

	def footer_sig
		move_down 200
		text "Submitted BY:",style: :bold,:align => :left
		move_up 15
		text "Signatures:",style: :bold,:align => :right
	end

end