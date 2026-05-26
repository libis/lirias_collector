
#encoding: UTF-8
# require "active_support/core_ext"
require 'active_support/core_ext/hash'
require 'active_support/core_ext/array'
# require 'jsonpath'
# require 'logger'
require 'nokogiri'
require 'active_support/core_ext/hash'
require 'active_support/isolated_execution_state'
require 'active_support/xml_mini'
# require 'pp'
require 'json'
require 'zlib' 
require 'open-uri'

=begin
Dir.glob("/records/alma_correction/ALMA_lirias_*.tar.gz").each do |tar_gz_archive|
    pp tar_gz_archive
    tar_resp = `cd /records/alma_correction/; tar -xzvf #{tar_gz_archive} -C /records/alma_correction/xml; cd -`
    Dir.glob("/records/alma_correction/xml/*.xml").each do |f|
        File.rename(f, "#{tar_gz_archive.gsub(".tar.gz",".xml")}")
    end 
end

Dir.glob("/records/alma_correction/lirias_*.tar.gz").each do |tar_gz_archive|
    pp tar_gz_archive
    tar_resp = `cd /records/alma_correction/; tar -xzvf #{tar_gz_archive} -C /records/alma_correction/json; cd -`
end
=end

id = "1302169"
Dir.glob("/records/alma_correction//primoVE_#{id}_*").each do|f|
    pp f
    json_file =  JSON.parse( File.read(f) )    ;
    xlmfile = "/records/alma_correction/xml/primoVE_#{id}_.xml"
    File.open(xlmfile, 'w') do |f|
        puts json_file.to_xml(root: "record")
        f.puts json_file.to_xml(root: "record")
    end
end

exit


Dir.glob("/records/alma_correction/ALMA_lirias_20240409_16*.xml").each do |xml_file|
    xml_doc  = Nokogiri::XML( File.read(xml_file) )
    xml_doc.xpath("//ListRecords/record").each { |record| 
    if record.xpath("deleted").empty?
        id = record.xpath("id").text
        pp id
        pp "/records/alma_correction/json/#{id[0,1]}/primoVE_#{id}_*"
    
        Dir.glob("/records/alma_correction/json/#{id[0,1]}/primoVE_#{id}_*").each do|f|
            pp f
            json_file =  JSON.parse( File.read(f) )    ;
            xlmfile = "/records/alma_correction/xml/primoVE_#{id}_.xml"
            File.open(xlmfile, 'w') do |f|
                f.puts json_file.to_xml(root: "record")
            end
        end
    end
    }
end

exit

@max_records_in_tar = 1000

Dir.glob("/records/alma_correction/xml/primoVE_*").each_slice( @max_records_in_tar )  { |filelist|
    doc = Nokogiri::XML("<ListRecords></ListRecords>")
      filelist.each { |xml_file|
        xml_record = File.open(xml_file) { |f| Nokogiri::XML(f) }
        doc.at('ListRecords').add_child(xml_record.search("record"))
        # File.delete( xml_file[:filename] )
      }   

      xmlfilename =File.join("/records/alma_correction/xml/", "tmp_xml_file_#{Time.now.to_i}_#{rand(1000)}.xml"); 

      File.open(xmlfilename, 'w') do |f|
        f.puts doc.to_xml
      end

      tarfilename =  "ALMA_lirias_#{Time.now.strftime("%Y%m%d_%H%M%S")}_#{rand(1000)}.tar.gz"
      tar_resp = `cd /records/alma_correction/tar/; tar -czf #{tarfilename} #{xmlfilename}; cd -`
      File.chmod(0666, File.join("/records/alma_correction/tar/",tarfilename) )

}
