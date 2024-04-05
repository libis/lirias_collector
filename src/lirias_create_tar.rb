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
    config.file = init_config[:config_file]

    options = {}
    collect = Collector::CollectRecords.new(config, logger: @logger,  options: options)

    Dir.glob(  File.join( config[:records_dir], '/*')  ).select {|f| File.directory? f}.each do |dir|
        

        erb_template = "<% if form.to_s==\"xml\" %>ALMA_<% end %>lirias_<%= oldest_file_date.strftime(\"%Y%m%d_%H%M%S\") %>_<%= rand(1000) %>.tar.gz"
        @logger.info( "create tar files from #{dir}")
        oldest_file_date = File.mtime( Dir.glob(dir).min_by {|f| File.mtime(f) } )
        
        form = "xml"
        
        filename = (ERB.new( erb_template)).result( binding )
        filelist =  Dir.glob( "#{dir}/*.xml" ).map{|f| { filename: f }  }
        file = collect.create_xml(filelist: filelist, tmp_output_dir: "/tmp")

        unless file.nil?
            @logger.info( "create tar [#{filename}] for #{form} files")
            collect.create_tar_from_filelist( dirname: config[:records_dir], directory_tar_files: File.dirname(file), filename: filename, filelist: [ File.basename(file) ] ) 
        end

        form = "json"
        
        filename = (ERB.new( erb_template)).result( binding )
        filelist =  Dir.glob( "#{dir}/*.json" )
        @logger.info( "create tar [#{filename}]  for #{form} files")
        
        filelist = filelist.map{|f| File.basename(f) }
        
        collect.create_tar_from_filelist( dirname: config[:records_dir], directory_tar_files: dir, filename: filename, filelist: filelist)   

        if Dir[ "#{dir}/*" ]&.empty?
            @logger.info( "remove empty dir #{dir}")
            FileUtils.rm_rf( dir )
        end

    end


rescue StandardError => e
    @logger.error("#{ e.message  }")
    @logger.error("#{ e.backtrace.inspect   }")
  
    importance = "High"
    subject = "[ERROR] #{config[:source_name]} creating tar"
    
    message = <<END_OF_MESSAGE
    
    <h2>Error while creating tar </h2>
    Creating tar using config: #{ config.path}/#{ config.file }
    <p>#{e.message}</p>
    <p>#{e.backtrace.inspect}</p>
    
    <hr>
    
    config[:records_dir] : #{config[:records_dir]}
    filename             : #{filename}
    filelist             : #{filelist}
    
END_OF_MESSAGE
  
    Collector::Utils.mailErrorReport(subject, message, importance, config)
    @logger.info("Creating tar is finished with errors")

    exit

ensure
  
    importance = "Normal"
    subject = "#{config[:source_name]} creating tar"
    message = <<END_OF_MESSAGE
  
    <h2> Creating tar</h2>
    Creating tar using config: #{ config.path}/#{ config.file }
    <H3>#{$0} </h3>

    <hr>
  
END_OF_MESSAGE
  
    Collector::Utils.mailErrorReport(subject, message, importance, config) 
    @logger.info("#{config[:source_name]} Parsing is finished without errors")
   

end




