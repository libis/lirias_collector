#encoding: UTF-8
$LOAD_PATH << '.' << './lib' << './rules/'

require 'data_collect'

#RECORDS_DIR = "#{File.dirname(__FILE__)}/./records"
RECORDS_DIR = "/records"

# create dit if it does not exist
Dir.mkdir("#{RECORDS_DIR}") unless Dir.exists?("#{RECORDS_DIR}")

# remove all *.xml file except those who start with lirias
# lirias_*.xml is used for Primo_VE
Dir.glob("#{RECORDS_DIR}/*.xml") do |f|
  unless File.basename(f).start_with?("lirias")
    File.unlink(f)
  end
end

if ARGV.empty?
  puts "USAGE #{__FILE__} rules"
  exit 1
else
  filename = ARGV[0]
  dc = DataCollect.new
  dc.runner(filename)
end
