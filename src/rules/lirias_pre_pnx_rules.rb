
=begin
#Get last ran date

############################################################### TEST ADAPTATIONS #####################################
# Set the configuration path to test_config => will read ./test_config/config.yml
# Default is ./config.yml or config/config.yml
# ConfigFile.path="test_config"
ConfigFile.config_file="config.yml"

require 'rules/lirias_pre_pnx/parsing_rules.rb'
require 'rules/lirias_pre_pnx/writing_rules.rb'
############################################################### TEST ADAPTATIONS #####################################

from_date = CGI.escape(DateTime.parse(config[:last_run_updates]).xmlschema)
from_date_deleted = CGI.escape(DateTime.parse(config[:last_run_deletes]).xmlschema)
=end

def collect_records()
  begin

    last_affected_when  = config[:last_run_updates]
    deleted_when        = config[:last_run_deletes]
  
    from_date          = CGI.escape(DateTime.parse(last_affected_when).xmlschema)
    from_date_deleted  = CGI.escape(DateTime.parse(deleted_when).xmlschema)
  
    url         = "#{config[:base_url]}#{ from_date  }"
    url_delete  = "#{config[:base_delete_url]}#{ from_date_deleted }"
    url_options = {user: config[:user], password: config[:password]}
   
    records_dir        = config[:records_dir]          || "test_records"
    record_template    = config[:record_template]      || "lirias_pre_pnx_template.erb"
    delete_template    = config[:delete_template]      || "lirias_delete_template.erb"
  
 
    max_updated_records  = config[:max_updated_records] || 1000
    max_deleted_records  = config[:max_deleted_records] || 50
    #tar_records          = config[:tar_records]         || true
    tar_records          = config[:tar_records]       
    one_xml_file         = config[:one_xml_file]        || false
    #remove_temp_files    = config[:remove_temp_files]   || true    
    remove_temp_files    = config[:remove_temp_files]   
    debugging            = config[:debugging]           || false
  
    unless records_dir.chr == "/"
      records_dir = "#{File.dirname(__FILE__)}/../#{records_dir}"
    end

    log("config config[:max_updated_records]  #{ config[:max_updated_records] } ")
    log("config max_updated_records  #{ max_updated_records } ")

=begin
#Create starting URL
  url = "#{config[:base_url]}#{from_date}"
  url_delete = "#{config[:base_delete_url]}#{from_date_deleted}"

  options = {user: config[:user], password: config[:password]}
  
  last_affected_when = config[:last_run_updates]
  deleted_when  = config[:last_run_deletes]

  c_dir = Dir.pwd
  ############################################################### TEST ADAPTATIONS #####################################
  #records_dir = "test_records"
  #records_dir = "/home/limo/dCollector/records"
  records_dir = "#{c_dir}/records"

  counter = 0
  dcounter = 0
  updated_records = 0
  max_updated_records = 500000
  deleted_records = 0
  max_deleted_records = 50000
  tar_records = true

  debugging = false

  if debugging
    max_updated_records = 1000
    max_deleted_records = 50
    tar_records = true
    #url = 'file://mock.xml'
    #url = 'https://lirias2repo.kuleuven.be/elements-cache/rest/publications?affected-since=2018-10-17T21%3A51%3A42.690Z&per-page=50'
    #url = 'file://bronbestanden/call_622.xml'
    #url_delete = nil
   
  end
=end

    # url = 'file://test_records/new_credit_roles.xml'

    counter = 0
    dcounter = 0
    updated_records = 0
    deleted_records = 0
    
    # More about jsonpath
    #https://www.pluralsight.com/blog/tutorials/introduction-to-jsonpath
    #url = "https://lirias2test.libis.kuleuven.be/elements-cache/rest/publications?per-page=10&affected-since=2018-03-14T20%3A44%3A14%2B01%3A00"

    log("Get Data affected-since #{from_date} ")
      
    while url
      log("Load URL : #{  url }")

      timing_start = Time.now
      #Load data
      data = input.from_uri(url, url_options)
      log("Data loaded in #{((Time.now - timing_start) * 1000).to_i} ms")

      tmp_records_dir = "#{records_dir}/records_#{Time.now.to_i}"
      tmp_not_claimed_records_dir = "#{records_dir}/records_not_claimed_#{Time.now.to_i}"
      
      resolver_data = {}
      resolver_authors = {}
      resolver_data_not_claimed_lirias_records = []

      timing_start = Time.now
      #Filter on Object
      if data.nil? 
        log("Error loading data: data is nil?")
      end 

      filter(data, '$..entry[*].object').each do |object|
        ######################### Parse_record ###  rules/test_lirias_pre_pnx/parsing_rules.rb ######

        parse_record(object)

        if  output[:deleted]
          dcounter += 1
  ##########       log("INFO id : #{    output[:id] } Not Claimed")
          #log("INFO output :-------------------------------------------")
          #log("INFO output : #{    output.raw }")
          #log("INFO output :-------------------------------------------")
      
          #output.to_tmp_file("templates/lirias_delete_template.erb",tmp_not_claimed_records_dir)
          output.to_tmp_file(delete_template,tmp_records_dir)
          resolver_data_not_claimed_lirias_records << output.raw.slice(:id, :deleted, :response_date)
        else
          last_affected_when = output[:updated][0]

          #output.to_tmp_file("templates/lirias_pre_pnx_template.erb",tmp_records_dir)
          output.to_tmp_file(record_template,tmp_records_dir)
          

          resolver_data_lirias_records = output.raw().slice(:id, :wosid, :scopus, :pmid, :doi, :isbn_13, :isbn10, :issn, :eissn, :additional_identifier, :files, :public_url, :author, :editor, :supervisor, :co_supervisor, :contributor)
          resolver_data[ resolver_data_lirias_records[:id].first ] = resolver_data_lirias_records
          counter += 1
        end


        #log("INFO id : #{    output[:id] }")
        
        output.clear()      
      end

      updated_records = counter
      not_claimed_records = dcounter

      log(" last_affected_when #{ last_affected_when } ")
      log(" records created #{ updated_records } ")
      log(" delete-records (not claimed) #{ dcounter } ")

      if one_xml_file
        filename      = "lirias_#{Time.now.to_i}.xml"
        full_filename =  "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_records_dir}/*.xml"

        create_large_xml(full_filename, directory_to_process)
      end

puts "tar_records #{tar_records}"

      if tar_records
        filename      = "lirias_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_records_dir}"

        create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_records_dir)
      end

      #create JSON files for resolver
      output.to_jsonfile(resolver_data, "lirias_resolver_data",records_dir)
      # output.to_jsonfile(resolver_authors, "lirias_resolver_author")

      if one_xml_file
        filename      = "lirias_not_claimed_#{Time.now.to_i}.xml"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process = "#{tmp_not_claimed_records_dir}/*.xml"
        create_large_xml(full_filename, directory_to_process)
      end

      if tar_records
        filename      = "lirias_not_claimed_#{Time.now.to_i}.tar.gz"
        full_filename = "#{records_dir}/#{filename}"
        directory_to_process  = "#{tmp_not_claimed_records_dir}"
        create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_not_claimed_records_dir)
      end

      #create JSON files for resolver
      if !resolver_data_not_claimed_lirias_records.empty?
        output.to_jsonfile(resolver_data_not_claimed_lirias_records, "lirias_resolver_deleted_data",records_dir)
      end

      #update config with the new data
      log(" update  config[:last_run_updates] with #{ last_affected_when } ")
      config[:last_run_updates] = last_affected_when

      #Filter next URL
      url = filter(data, '$..link[?(@._rel=="next")]._href').first || nil
      log("Converted in #{((Time.now - timing_start) * 1000).to_i} ms")

      log("....> nex url: #{url}")
      log("counter: #{counter}")
      log("max_updated_records: #{max_updated_records}")

      if counter > max_updated_records 
        url = nil
      end
     
      log("....> nex url: #{url}")
 
    end

    log("Get Deleted affected-since #{from_date_deleted} ")  

    #url_delete = "https://lirias2test.libis.kuleuven.be/elements-cache/rest/deleted/publications?per-page=1000&deleted-since=2018-04-24T13%3A14%3A06%2B00%3A00"

    log("Load URL (delete) #{url_delete}")

    dcounter = 0
    while url_delete
      timing_start = Time.now
      #Load data
      data = input.from_uri(url_delete, url_options)
      tmp_records_dir = "#{records_dir}/records_delete_#{Time.now.to_i}"
      
      resolver_deleted_data = {}

      log("Data loaded in #{((Time.now - timing_start) * 1000).to_i} ms")

      resolver_data_lirias_records = []

      timing_start = Time.now
      #Filter on Object
      filter(data, '$..entry[*].deleted_object').each do |object|
        output[:id] = filter(object, '@._id')
        output[:deleted] = filter(object, '@._deleted_when')

        #log(" record id #{ output[:id] } deleted")

        #output.to_tmp_file("templates/lirias_delete_template.erb",tmp_records_dir)
        output.to_tmp_file(delete_template,tmp_records_dir)
        
        deleted_when = output[:deleted][0]
        resolver_data_lirias_records << output.raw()

        #results are sorted by deleted_when
        dcounter += 1
        output.clear()  
      end

      deleted_records = dcounter
      #log(" deleted_when #{ deleted_when } ")
      log(" delete-records created #{ deleted_records } ")

      if one_xml_file
        filename      = "lirias_deleted_#{Time.now.to_i}.xml"
        full_filename =  "#{records_dir}/#{filename}"
        directory_to_process = "#{tmp_records_dir}/*.xml"
        create_large_xml(full_filename, directory_to_process)
      end

      if tar_records
          filename      = "lirias_deleted_#{Time.now.to_i}.tar.gz"
          full_filename = "#{records_dir}/#{filename}"
          directory_to_process  = "#{tmp_records_dir}"
          create_tar(full_filename, directory_to_process)
      end

      if remove_temp_files
        remove_temp_xml(tmp_records_dir)
      end

      if !resolver_data_lirias_records.empty?
        output.to_jsonfile(resolver_data_lirias_records, "lirias_resolver_deleted_data",records_dir)
      end

      #update config with the new data
      log("update config[:last_run_delete] with #{ last_affected_when } ")
      config[:last_run_deletes] = deleted_when

      url_delete = filter(data, '$..link[?(@._rel=="next")]._href').first || nil

      if dcounter > max_deleted_records || debugging
        url_delete = nil
      end
    end
    
  ensure
    log("Counted #{updated_records} updated records")
    log("Counted #{not_claimed_records} deleted records (not claimed)")
    log("Counted #{deleted_records} deleted records")
    # config[:last_run_updates] = Time.now.xmlschema
  end
end
