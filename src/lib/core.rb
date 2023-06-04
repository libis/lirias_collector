
require 'data_collector'
require_relative 'input_extension'
require_relative 'config_file'
require_relative 'mail'

module Collector
  class CollectRecords
    include DataCollector::Core

    attr_accessor :config, :options

    def initialize(config, url_options: {}, logger: Logger.new(STDOUT), options: {} )
      @logger  = logger

      @config  = config
      @options = options
      @retries = 0
      @total_nr_parsed_records = 0

      last_affected_when  = @config[:last_run_updates]
      deleted_when        = @config[:last_run_deletes]

      @from_date          = CGI.escape(DateTime.parse(last_affected_when).xmlschema)
      @from_date_deleted  = CGI.escape(DateTime.parse(deleted_when).xmlschema)

      # @url         = "#{@config[:base_url]}#{ @from_date  }"
      # @url_delete  = "#{@config[:base_delete_url]}#{ @from_date_deleted }"
      @url_options = {user: @config[:user], password: config[:password]}


      @records_dir          = @config[:records_dir]         || "test_records"

      @max_updated_records  = @config[:max_updated_records] || 1000
      @max_deleted_records  = @config[:max_deleted_records] || 50
      @tar_records          = false
      @tar_records          = @config[:tar_records]
      @max_records_in_tar   = @config[:max_records_in_tar] || 4
      @filename_list        = { :updated => { :xml => [], :json => [] },
                                :deleted => { :xml => [], :json => [] }
                              }
      @record_filename_erb_template = @config[:record_filename_erb_template] || 'record_<%= data[:id] %>'
      @record_filename_erb_template = ERB.new (@record_filename_erb_template)
      @tar_filename_erb_template = @config[:tar_filename_erb_template] || 'record_<%= time %>_<%= rand(1000) %>.tar.gz'
      @tar_filename_erb_template = ERB.new (@tar_filename_erb_template)
      

      @debugging            = false
      @debugging            = @config[:debugging]

    end

    

    def collect_records()
      begin
        @logger.info ("Get Data affected-since #{ @from_date } ")
        @logger.info ("URL #{ @url  } ")

        if @config[:rule_set].nil?
          raise "Ruleset is mandotory in config"
        else
          rule_set =  @config[:rule_set].constantize
        end


        unless @config[:current_processing_updates].to_s.empty?
          @from_date =  CGI.escape(DateTime.parse( @config[:current_processing_updates] ).xmlschema)
        end


        if @config[:base_url].end_with?("affected-since=")
          @url = "#{@config[:base_url]}#{ @from_date  }"
        else
          @url = @config[:base_url]
        end

        # url = @config
  
        collect(url: @url, url_options: @url_options, rule_set: rule_set)
        
        most_recent_parsed_record_date = output.data[:metadata][:affected_date].max.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        return  @total_nr_parsed_records, most_recent_parsed_record_date

      rescue StandardError => e
        # @logger.error("#{ e.message  }")
        # @logger.error("#{ e.backtrace.inspect   }")
        raise e
      end
    end

    def collect_deleted_records
      begin
        @logger.info ("Get Data deleter-after #{ @from_date_deleted } ")
        @logger.info ("URL #{ @url_delete  } ")

        if @config[:delete_rule_set].nil?
          raise "delete_rule_set is mandotory in config"
        else
          rule_set =  @config[:delete_rule_set].constantize
        end

        unless @config[:current_processing_deletes].to_s.empty?
          @from_date_deleted =  CGI.escape(DateTime.parse( @config[:current_processing_deletes] ).xmlschema)
        end

        if @config[:base_delete_url].end_with?("deleted-since=")
          @url_delete = "#{@config[:base_delete_url]}#{ @from_date_deleted  }"
        else
          @url_delete = @config[:base_delete_url]
        end



        # url = @config

        collect(url: @url_delete, url_options: @url_options, rule_set: rule_set)
        
        most_recent_parsed_record_date = output.data[:metadata][:deleted_when].max.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        return  @total_nr_parsed_records, most_recent_parsed_record_date

      rescue StandardError => e
        # @logger.error("#{ e.message  }")
        # @logger.error("#{ e.backtrace.inspect   }")
        raise e
      end
    end


    def collect( url: nil, url_options: nil, rule_set: nil )
      begin

        DataCollector::Input.new( @logger )

        pp "####################################################################################"
        pp "# Should the input resonpse be saved to disk for later use or                      #" 
        pp "# Collect retrieve and parse OR first download the data and then parse the data ?  #"
        pp "####################################################################################"

        while url
          nr_parsed_records = 0          
          timing_start = Time.now
          #Load data

          output.clear

          data = input.from_uri(url, url_options)
          @logger.info("Data loaded in #{((Time.now - timing_start) * 1000).to_i} ms")

          if data.nil?
            raise "No data avalaible from #{@url}"
          else
            timing_start = Time.now
            parse_data(data: data, rule_set: rule_set)
            @logger.info("Data parsed in #{((Time.now - timing_start) * 1000).to_i} ms")
          end

          @logger.debug("metadata.results_count #{ output.data[:metadata][:results_count] }")
          # pp output.data[:metadata]
          # pp output.data[:metadata][:results_count]
          if output.data[:metadata][:results_count] == 0
            @logger.warn("No records found")
            return  @total_nr_parsed_records
          end
=begin
          #########################################################################################################################################
          # pp output.data[:data]
          #debug_properties=[:parent_title, :journal_title, :journal, :article_title, :book_title, :title, :ispartof ]
          #debug_properties=[:identifiers ]
          #debug_properties=[:journal, :parent_title, :search_creationdate, :publication_date, :online_publication_date, :acceptance_date, :search_startdate, :search_enddate, :creationdate ]
          #debug_properties=[:risdate, :creationdate, :search_creationdate, :search_startdate, :search_enddate, :publication_date]
          #debug_properties=[:serie, :start_date, :location, :finish_date, :relation ]
          #debug_properties=[:title, :linktorsrc , :files ,  :doi, :oa, :facets_toplevel ]
          #debug_properties=[:facets_rsrctype, :type]
          debug_properties=[:id, :claimed, :title]

          data =  output.data[:data].is_a?(Array) ? output.data[:data] : [output.data[:data]]
          data.each do |d|
            debug_properties.each do |property|
              pp " --- #{property} [#{ d[property].class }] -- "
              pp d[property]
              
            end
            unless d[:claimed]
              pp "=============>>>>>>  NOT CLAIMED !!!!!!!"
            
            end
            if d[:deleted]
              pp "=============>>>>>>  DELETED !!!!!!!"
            end

          end
          #########################################################################################################################################
=end

          url = output.data[:metadata][:next_url]

          output.data[:metadata][:affected_date] = [output.data[:metadata][:affected_date]] unless output.data[:metadata][:affected_date].is_a?(Array)
          output.data[:metadata][:deleted_when] = [output.data[:metadata][:deleted_when]] unless output.data[:metadata][:deleted_when].is_a?(Array)

          output.data[:data] = [output.data[:data]] unless output.data[:data].is_a?(Array)

          output.data[:data].each do | data |

            filename = @record_filename_erb_template.result( binding ) 

            if data[:deleted]
              tmp_output_dir = @options[:tmp_deleted_records_dir]
            else
              tmp_output_dir = @options[:tmp_records_dir]
            end

            file = output.to_jsonfile(data, filename, tmp_output_dir)

            if data[:deleted]
              @filename_list[:deleted][:json] << { :filename => file, :deleted => data[:deleted], :updated => data[:updated] } 
            else
              @filename_list[:updated][:json] << { :filename => file, :deleted => data[:deleted], :updated => data[:updated] } 
            end

            # create XML record.
            # Used in ALMA Lirias Import Profile
            # only for records 
            # - with publication_status must be "published", "published online" or "accepted"
            # - with a linktorsrc              
            unless ( data[:linktorsrc].nil? || data[:linktorsrc].empty?)
              unless data[:local_field_08].nil?
                if [ "published", "published online", "accepted"].include?(data[:local_field_08].downcase)
                #   pp "----------------------"
                #   pp data[:linktorsrc]
                #   pp data[:local_field_08]
                  file = output.to_xmlfile(data, filename, records_dir=tmp_output_dir, root="record")
                  @filename_list[:updated][:xml]  << { :filename => file, :deleted => data[:deleted], :updated => data[:updated] } 
                end
              end
            end

            unless ( data[:deleted].nil? )
              file = output.to_xmlfile(data, filename, records_dir=tmp_output_dir, root="record")
              @filename_list[:deleted][:xml] << { :filename => file, :deleted => data[:deleted], :updated => data[:updated] } 
            end

            @total_nr_parsed_records += 1
            nr_parsed_records += 1
          end
        
          @logger.info("Data saved to disk #{((Time.now - timing_start) * 1000).to_i} ms")
          # timing_start = Time.now

          if @tar_records
            @logger.debug("Deliver recods in tar")
            @filename_list.each_key do | type |
              @filename_list[type].each_key do | form|               
                if @filename_list[type][form].size >= @max_records_in_tar
                  @filename_list[type][form] = @filename_list[type][form].each_slice( @max_records_in_tar ).to_a.select do |filelist|
                    if filelist.size == @max_records_in_tar
                      tar_records( type: type, form: form, filelist: filelist )
                      false
                    else
                      true
                    end
                  end
                  @filename_list[type][form].flatten! 
                end
              end
            end
          end

          # @url = nil
          if @max_updated_records < @total_nr_parsed_records
            @logger.warn("max_updated_records has been reached")
            url = nil
          end

          @config[:current_processing_updates] = output.data[:metadata][:affected_date].max&.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
          @config[:current_processing_deletes] = output.data[:metadata][:deleted_when].max&.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
          
          @logger.info("nr_parsed_records: #{nr_parsed_records}")
          @logger.info("total_nr_parsed_records: #{@total_nr_parsed_records}")
          @logger.info ("URL #{ url  } ")
        end

        if @tar_records
          @filename_list.each_key do | type|
            @filename_list[type].each_key do | form |
              filelist = @filename_list[type][form]
              tar_records( type: type,  form: form, filelist: filelist )
              @filename_list[type][form] = []
            end
          end
        end

      rescue StandardError => e
        # @logger.error("#{ e.message  }")
        # @logger.error("#{ e.backtrace.inspect   }")
        raise e
      end
    end


    def parse_data( data:{}, rule_set: nil )
      begin

        if rule_set.nil?
          raise "rule_set is required to parse file"
        end

#        @logger.debug(" options #{ @options }")
        rules_ng.run( rule_set['rs_metadata'], data, output, @options)
        rules_ng.run( rule_set['rs_data'], data, output, @options)
        
        output.crush
        output
      rescue StandardError => e
        @logger.error("Error parsing file  #{file} ")  
        @logger.error("#{ e.message  }")
        @logger.error("#{ e.backtrace.inspect   }")
        @logger.error( "HELP, HELP !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        raise e
        exit
      end
    end

    def tar_records( type: :new, form: "json", filelist: [] )
          # time = Time.now.strftime("%Y%m%d_%H%M%S")
          #filename = "lirias_#{time}_#{rand(1000)}.tar.gz"

          filename = @tar_filename_erb_template.result( binding ) 
          @logger.debug("tar filename: #{filename}")

          if type == :updated
            tmp_output_dir = @options[:tmp_records_dir]
          end
          if type == :deleted
            tmp_output_dir = @options[:tmp_deleted_records_dir]
          end

          if form == :xml
            file = create_xml(filelist: filelist, tmp_output_dir: tmp_output_dir)
            unless file.nil?
              @logger.info( "create tar for #{form} files")
              create_tar_from_filelist( dirname: @records_dir, directory_tar_files: File.dirname(file), filename: filename, filelist: [ File.basename(file) ] ) 
            end
          end
          if form == :json
            @logger.info( "create tar for #{form} files")
            filelist = filelist.map{|f| File.basename(f[:filename]) }
            create_tar_from_filelist( dirname: @records_dir, directory_tar_files: tmp_output_dir, filename: filename, filelist: filelist)     
          end
    end
  
    def create_tar_from_filelist(dirname: "/records/", directory_tar_files: "/tmp/", filename: "record", filelist: [])   
      unless filelist&.empty?
        current_dir = Dir.pwd
        if filelist.size > 0
          tarfilename =  File.join( dirname, filename);
          tar_resp = `cd #{directory_tar_files}; tar -czf #{tarfilename} #{filelist.join(' ')} --remove-files; cd #{current_dir} `
          File.chmod(0666, tarfilename)
        end
      end
    end

    def create_xml(filelist: [], tmp_output_dir: "/tmp")

      unless filelist.empty?
        doc = Nokogiri::XML("<ListRecords></ListRecords>")
        filelist.each { |xml_file|
          xml_record = File.open(xml_file[:filename]) { |f| Nokogiri::XML(f) }
          doc.at('ListRecords').add_child(xml_record.search("record"))
          File.delete( xml_file[:filename] )
        }   
        xmlfilename =File.join(tmp_output_dir, "tmp_xml_file_#{rand(100)}.xml");  

        File.open(xmlfilename, 'w') do |f|
          f.puts doc.to_xml
        end

        return xmlfilename
      end
    end

  end
end
