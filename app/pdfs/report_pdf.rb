class ReportPdf < Prawn::Document

	def initialize(approved,rejected)
		super(top_margin:70)
		@approved = approved
		@rejected = rejected
		@total = @approved + @rejected
		report_name
		table_data
		footer_sig
	end

	def report_name
		text "Applicants Reviewed Reports", size:30 , style: :bold,:align => :center
		move_down 5
		text "as on #{Date.today.strftime('%d %B %Y')}",style: :bold,:align => :center
		move_down 20
		text "Total number of applicants : #{@total}"
		move_down 10
	end

	def table_data
		text "Application Review Amount : "
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
		[["Approved","Rejected"]] + 
		[[@approved,@rejected]]
	end

	def footer_sig
		move_down 200
		text "Submitted BY:",style: :bold,:align => :left
		move_up 15
		text "Signatures:",style: :bold,:align => :right
	end

end