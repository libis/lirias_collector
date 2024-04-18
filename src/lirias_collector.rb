#encoding: UTF-8
$LOAD_PATH << '.' << './lib' << "#{File.dirname(__FILE__)}" << "#{File.dirname(__FILE__)}/lib"
# require "unicode"
require 'logger'
require 'core'
require 'mappings'

ROOT_PATH = File.join( File.dirname(__FILE__), './')

begin

    @logger = Logger.new(STDOUT)
    @logger.level=Logger::DEBUG      

    init_config = {
      :config_path => File.join(ROOT_PATH, 'config'),
      :config_file => "config.yml",
    }
    
    config = Collector::ConfigFile
    config.path = init_config[:config_path]
    config.name = init_config[:config_file]
    
    RULES_PATH = "#{File.absolute_path(config[:rules_base])}/*.rb"
    
    @logger.debug("Loading rules from #{RULES_PATH}")
    Dir.glob(RULES_PATH).each do |file|
      file.gsub!(/.rb$/)
      @logger.debug("Loading rules from  file #{File.basename(file)}")
      require file
    end

    options = {
        :lirias_type_2_limo_type => LIRIAS_TYPE_2_LIMO_TYPE,
        :lirias_language => LIRIAS_LANGUAGE,
        :lirias_format_mean => FORMAT_MEAN,
        :prefixid => "",
        :tmp_records_dir => File.join( config[:records_dir],"records_#{Time.now.to_i}"),
        :tmp_deleted_records_dir => File.join( config[:records_dir],"records_not_claimed_#{Time.now.to_i}")
    }

    start_process  = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z") # (2022-10-27T05:31:05.413+02:00)


    collect = Collector::CollectRecords.new(config, logger: @logger,  options: options)
    collect.options = options

    total_nr_parsed_records, most_recent_parsed_record_date = collect.collect_records()


    #pp "#{config[:source_name]} parsing [#{total_nr_parsed_records}]"
    #pp "#{config[:source_name]} most_recent_parsed_record_date [#{most_recent_parsed_record_date}]"
    #pp "#{config[:source_name]} Process started on             [#{start_process}]"

    @logger.info ("Update config[last_parsing_datetime] with #{most_recent_parsed_record_date }")
    
    config[:last_run_updates] = most_recent_parsed_record_date
    config[:current_processing_updates] = ""



    total_nr_parsed_deleted_records, most_recent_parsed_deleted_record_date = collect.collect_deleted_records()
    
    #pp "#{config[:source_name]} parsing [#{total_nr_parsed_records}]"
    #pp "#{config[:source_name]} most_recent_parsed_deleted_record_date [#{most_recent_parsed_deleted_record_date}]"
    #pp "#{config[:source_name]} Process started on             [#{start_process}]"

    @logger.info ("Update config[last_run_deletes] with #{most_recent_parsed_deleted_record_date }")
    config[:last_run_deletes] = most_recent_parsed_deleted_record_date

    config[:current_processing_deletes] = ""
    

rescue StandardError => e
    @logger.error("#{ e.message  }")
    @logger.error("#{ e.backtrace.inspect   }")
  
    importance = "High"
    subject = "[ERROR] #{config[:source_name]} parsing"
    
    message = <<END_OF_MESSAGE
    
    <h2>Error while parsing #{config[:source_name]} data</h2>
    Parsing using config: #{ config.path}/#{ config.file }
    <p>#{e.message}</p>
    <p>#{e.backtrace.inspect}</p>
    
    <hr>
    
END_OF_MESSAGE
  
    Collector::Utils.mailErrorReport(subject, message, importance, config)
    @logger.info("#{config[:source_name]} Parsing is finished with errors")

ensure
  
    importance = "Normal"
    subject = "#{config[:source_name]} parsing [#{@total_nr_parsed_records}]"
    message = <<END_OF_MESSAGE
  
    <h2>Parsing #{config[:source_name]} data</h2>
    Parsing using config: #{ config.path}/#{ config.name }
    <H3>#{$0} </h3>

    <hr>
  
    @tar_filename_erb_template : #{@tar_filename_erb_template}
    @options[:tmp_records_dir] : #{ options[:tmp_records_dir] }
    @options[:tmp_deleted_records_dir]: #{ options[:tmp_deleted_records_dir] }

END_OF_MESSAGE
  

    Collector::Utils.mailErrorReport(subject, message, importance, config) 
    @logger.info("#{config[:source_name]} Parsing is finished without errors")
   
end




