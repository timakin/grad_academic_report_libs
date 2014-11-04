require 'csv'


CSV.open("../crunchbase_data/permalink.csv", 'w') do |row|
	CSV.foreach("../crunchbase_data/copied_people.csv") do |excsv|
		@raw_url = excsv[0]
		@http_removed = excsv[0].slice!(33..-1)
		@question_position = @http_removed.index("?")
		@result = @http_removed.slice!(0..@question_position-1)
	  puts @result
	  row << [@result]
	end
end