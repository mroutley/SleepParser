THRESHOLD_DAYS = 10 # Sets the number of days prior to today to include in the export

require 'date'
class SleepRecord
    
  attr_reader :start, :duration, :quality
    
  def initialize(start, stop, quality)
    @start = start
    @duration = (24*(stop - start).to_f).round(1) # Convert days to hours
    @quality = quality
  end
  
  def in_range? # Determines if the SleepRecord is within the threshold date
    @start > Date.today - THRESHOLD_DAYS
  end
    
    def to_csv # Format the start to month day and output as a csv row
      "#{@start.strftime("%m/%d")},#{@duration}"
    end
    
    def to_s # Summary format for the record
      "On #{@start.strftime("%m/%d")} slept for #{@duration} hours"
    end
    
end

require 'csv'
class SleepParser
    
  attr_reader :sleep_log
    
  def initialize
		@sleep_log = []
	end
    
	def read_in_csv_data(csv_file_name)
		CSV.foreach(csv_file_name, :col_sep => ";", headers: true, :converters => :all, :row_sep => "\r\r\n") do |row|
	    @sleep_log << SleepRecord.new(row["Start"],row["End"],row["Sleep quality"]) unless row.empty?
		end
	end
    
  def to_csv
    puts "Date,Quality"
    @sleep_log.each {|record| puts record.to_csv  if record.in_range?}
  end
    
end

reader = SleepParser.new
ARGV.each do |csv_file_name|
  reader.read_in_csv_data(csv_file_name)
end
reader.to_csv
