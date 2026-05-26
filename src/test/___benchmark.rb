#encoding: UTF-8
$LOAD_PATH << '../' << '../lib' << "#{File.dirname(__FILE__)}../" << "#{File.dirname(__FILE__)}/../lib"

require 'benchmark'
require 'logger'
require 'core'
require_relative '../mappings'
# require "unicode"

=begin
begin

    ROOT_PATH = File.join( File.dirname(__FILE__), '../')

    init_config = {
      :config_path => File.join(ROOT_PATH, 'config/'),
      :config_file => "config.yml",
    }
    
    config = Collector::ConfigFile
    config.path = init_config[:config_path]
    config.file = init_config[:config_file]
    
    RULES_PATH = "#{File.absolute_path(config[:rules_base])}/*.rb"
    
    Dir.glob(RULES_PATH).each do |file|
      file.gsub!(/.rb$/)
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

    DataCollector::Input.new( )
    one_record_output = DataCollector::Output.new

    url = "file:///app/src/test/fixtures/test.xml"
    url_options = {}

    data = input.from_uri(url, url_options)

  =begin    
    rule_set = RULE_SET_v2_1
    rules_ng.run( rule_set['rs_data'], data, output, options)

    exit
  =end

    n = 5

    Benchmark.bm do |benchmark|
        benchmark.report("RULE_SET_v2_1") do
            n.times do
                rule_set = RULE_SET_v2_1
                rules_ng.run( rule_set['rs_data'], data, output, options)
            end
        end
        benchmark.report("RULE_SET_v2_0") do
            n.times do
                rule_set = RULE_SET_v2_0
                rules_ng.run( rule_set['rs_data'], data, output, options)
            end
        end
    end
end
=end