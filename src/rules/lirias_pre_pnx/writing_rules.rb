def create_tar(tarfilename, directory_to_tar)
  c_dir = Dir.pwd
  if Dir.exist?(directory_to_tar) 
    log("INFO Start tar cd #{directory_to_tar}; tar -czf #{tarfilename} *.xml; cd #{c_dir}")

    tar_resp = `cd #{directory_to_tar}; tar -czf #{tarfilename} *.xml; cd #{c_dir}`

    if $?.exitstatus != 0
      log("ERROR in creating tar.gz")
    end
  end
end

def remove_temp_xml(directory_to_process)
  begin
    log("INFO remove dir #{directory_to_process}")

    FileUtils.rm_rf(directory_to_process)
  rescue Exception => e
    log("ERROR remove dir [#{directory_to_process}] with temp xml-files #{e.message}")
  end
end

def create_large_xml(xmlfilename, directory_to_process)
  begin 
    log("INFO Start Processing #{directory_to_process}")
    dir_list = Dir.glob(directory_to_process)

    unless dir_list.empty?
      first = File.open(dir_list.shift)
      xml_result = Nokogiri::XML( first )
      first.close

      xml_result = dir_list.reduce(xml_result) { |xml_result, file|
          xml_file = File.open(file)
          record = Nokogiri::XML( xml_file ).search('record')
          xml_result.at('ListRecords').add_child(record)
          xml_file.close
          xml_result
      }
      
      File.open(xmlfilename, 'wb:UTF-8') do |f|
        f.puts xml_result.to_xml
      end
    end

  rescue Exception => e
      log("ERROR creating BIG xml #{e.message}")
  end
end
