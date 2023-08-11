#encoding: UTF-8
$LOAD_PATH << '.' << '../lib' << "#{File.dirname(__FILE__)}" << "#{File.dirname(__FILE__)}/lib" << "#{File.dirname(__FILE__)}/../lib"
require 'core'
require "deepsort"
require "logger"

# require "unicode"
require "data_collector"
include DataCollector::Core

ROOT_PATH = File.join( File.dirname(__FILE__), '../')

pp  File.dirname(__FILE__)

init_config = {
    :config_path => File.join(ROOT_PATH, 'config'),
    :config_file => "config.yml",
}

pp init_config[:config_path]

config = Collector::ConfigFile
config.path = init_config[:config_path]
config.file = init_config[:config_file]

RULES_PATH = "#{File.absolute_path(config[:rules_base])}/*.rb"

FIXTURES_PATH  = File.join( ROOT_PATH , "/fixtures")

@logger = Logger.new(STDOUT)
@logger.level=Logger::DEBUG      


Dir.glob(RULES_PATH).each do |file|
  file.gsub!(/.rb$/)
  require file
end

DEBUG = false

RULE_SET = {
    'rs_metadata' => {
        'metadata' => { '@' => lambda { |d,o| 
          out = DataCollector::Output.new
          pp 'rs_this_url' if DEBUG
          rules_ng.run(RULE_SET['rs_this_url'], d, out, o)
          pp 'rs_next_url' if DEBUG
          rules_ng.run(RULE_SET['rs_next_url'], d, out, o)
          pp 'rs_affected_date' if DEBUG
          rules_ng.run(RULE_SET['rs_affected_date'], d, out, o)
          pp 'rs_deleted_when' if DEBUG
          rules_ng.run(RULE_SET['rs_deleted_when'], d, out, o)
          out.data
        } }
      },
      'rs_next_url' => {
        'next_url' => { '$.feed.pagination.page[?(@._position=="next")]' => lambda { |d,o| 
          d["_href"]
        } }
      },
      'rs_this_url' => {
        'items_per_page' => { '$.feed.pagination[?(@page[?(@._position=="this")])]' => lambda { |d,o| 
          d["_items_per_page"]
        } },
        'results_count' => { '$.feed.pagination[?(@page[?(@._position=="this")])]' => lambda { |d,o| 
          d["_results_count"]
        } }
      },  
      'rs_affected_date' => {
        'affected_date' => { '$.feed.entry[?(@object)]' => lambda { |d,o| 
          unless d["object"].nil?
           DateTime.parse( d["object"]["_last_affected_when"] )
          end
        } }
      },
      'rs_deleted_when' => {
        'deleted_when' => { '$.feed.entry[?(@deleted_object)]' => lambda { |d,o| 
          unless d["deleted_object"].nil?
            DateTime.parse( d["deleted_object"]["_deleted_when"] )
          end
        } }
      },
    'rs_data' => {
        'data' => {'$.feed.entry' => lambda { |d,o|
            unless d['deleted_object'].nil?
                rdata = { 
                    :id  => d['deleted_object']['_id'],
                  }.with_indifferent_access
                  return rdata
            end

            rdata = { 
                :id          => d['object']['_id'],
                :lirias_type => d['object']['_type']
            }.with_indifferent_access


            pp d['object']['_type']
            if d['object']['_type'] == "research_dataset"
              rdata[:is_dataset] = true
            end

            out = DataCollector::Output.new
            pp 'rs_merged_record' if DEBUG
            rules_ng.run( RULE_SET['rs_merged_record'], d, out, o)
            rdata.merge!( out.data[:record].to_h )
            out.clear
            
            unless rdata['publisher_url'].nil? && rdata['additional_identifier_with_http'].nil?
              unless rdata['files'].nil?
                rdata[:record_with_files_and_url_in_metadata] = true
              end
            end

            unless rdata['doi'].nil?
              unless rdata['files'].nil?
                rdata[:record_with_files_and_doi] = true
              end
            end

            

            rdata
         } }
    },
    'rs_merged_record' => {
        'record' => {'$.object.records.record[?(@._source_name=="merged")].native' => lambda { |d,o|
            out = DataCollector::Output.new
            pp 'rs_record' if DEBUG
            rules_ng.run( RULE_SET['rs_record'], d, out, o)
            out.data
        }}
    },
    'rs_record' => {
        #'title'  => '$.field[?(@._name=="title")].text',
        #'alternative_title'  => '$.field[?(@._name=="c-alttitle")].text',
        #'serie' => '$.field[?(@._name=="series")].text',
        #'book_serie' => '$.field[?(@._name=="c-series-editor")].text',
        #'edition' => '$.field[?(@._name=="edition")].text',
        #'volume' => '$.field[?(@._name=="volume")].text',
        #'issue' => '$.field[?(@._name=="issue")].text',
        #'medium' => '$.field[?(@._name=="medium")].text',
        #'pagination' => '$.field[?(@._name=="pagination")][?( @._display_name==( "Pagination" || "Number of pages") )].pagination',
        #'number_of_pages' => '$.field[?(@._name=="pagination")][?( @._display_name==( "Pagination" || "Number of pages") )].pagination.page_count',
    
        #'publisher' => '$.field[?(@._name=="publisher")].text',
        'publisher_url' => '$.field[?(@._name=="publisher-url")].text',
        #'place_of_publication' => '$.field[?(@._name=="place-of-publication")].text',
    
        'isbn_10' => '$.field[?(@._name=="isbn-10")].text',
        'isbn_13' => '$.field[?(@._name=="isbn-13")].text',
        'doi' => '$.field[?(@._name=="doi")].text',
        
        'eissn' => '$.field[?(@._name=="eissn")].text',
        'external_identifiers' => { '$.field[?(@._name=="external-identifiers")].identifiers.identifier' => lambda { |d,o| d["$text"] } },

        'other_identifier' => '$.field[?(@._name=="c-identifier-other"].text',
        'other_identifier_type' => '$.field[?(@._name=="c-identifierother-type")].text',

        'other_identifiers_handle' => '$.field[?(@._name=="c-identifier-other" && @._type="handle")].text',
        'other_identifiers_url' => '$.field[?(@._name=="c-identifier-other" && @._type="url")].text',
        'other_identifiers_urn' => '$.field[?(@._name=="c-identifier-other" && @._type="urn")].text',
        'other_identifiers_purl' => '$.field[?(@._name=="c-identifier-other" && @._type=purl")].text',
        'other_identifiers_ark' => '$.field[?(@._name=="c-identifier-other" && @._type="ark")].text',

        'additional_identifier' => '$.field[?(@._name=="c-additional-identifier")].items.item',
        'additional_identifier_with_http' => { '$.field[?(@._name=="c-additional-identifier")].items.item' => lambda { |d,o|
          if d.match(/^http/)
            d
          end
        }},

        'is_open_access' => '$.field[?(@._name=="is-open-access")].boolean',
        'open_access_status' => '$.field[?(@._name=="open-access-status")].text',

        #'abstract'  => '$.field[?(@._name=="abstract")].text',
        #'author_url' => '$.field[?(@._name=="author-url")].text',
        
        #'publication_status' => '$.field[?(@._name=="publication-status")].text',
        #'note' => '$.field[?(@._name=="notes")].text',
        #'numbers' => '$.field[?(@._name=="numbers")].text',
        #'chapter_number' => '$.field[?(@._display_name=="Chapter number")].text',
        #'abstract_number' => '$.field[?(@._display_name=="Abstract number")].text',
        #'report_number' => '$.field[?(@._display_name=="Report number")].text',
        #'paper_number' => '$.field[?(@._display_name=="Paper number")].text',
        #'article_number' => '$.field[?(@._display_name=="Article number")].text',
    
        #'parent_title' => '$.field[?(@._name=="parent-title")].text',
        #'name_of_conference' => '$.field[?(@._name=="name-of-conference")].text',
        #'location' => '$.field[?(@._name=="location")].text',

        #'journal' => '$.field[?(@._name=="journal")].text',
        'issn' => '$.field[?(@._name=="issn")].text',
        #'pii' => '$.field[?(@._name=="pii")].text',
        #'language' => '$.field[?(@._name=="language")].text',
        #'patent_number' => '$.field[?(@._name=="patent-number")].text',

        #'patent_status' => '$.field[?(@._name=="patent-status")].text',
        #'commissioning_body' => '$.field[?(@._name=="commissioning-body")].text',

        #'peer_reviewed' => '$.field[?(@._name=="c-peer-review")].text',
        #'invitedby' => '$.field[?(@._name=="c-invitedby")].text',
        
        #'funding_acknowledgements' => '$.field[?(@._name=="funding-acknowledgements")].funding_acknowledgements.acknowledgement_text',
        #'vabb_type' => '$.field[?(@._name=="c-vabb-type")].text',
        #'vabb_identifier' => '$.field[?(@._name=="c-vabb-identifier")].text',
        #'historic_collection' => '$.field[?(@._name=="c-collections-historic")].items.item',

        #'public_url' => '$.field[?(@._name=="public-url")].text',

        #'professional_oriented' => { '$.field[?(@._name=="c-professional")].boolean' => lambda { |d,o| d.to_s } },
        #'confidential' => { '$.field[?(@._name=="confidential")].boolean' => lambda { |d,o| d.to_s } },
        #'number_of_pieces' => { '$.field[?(@._name=="number-of-pieces")].boolean' => lambda { |d,o| d.to_s } },
        #'version' => { '$.field[?(@._name=="version")].boolean' => lambda { |d,o| d.to_s } },

        'accessright' =>  '$.field[?(@._name=="c-accessrights")].text',
        #'venue_designart' =>  '$.field[?(@._name=="c-venue-designart")].items.item',
        #'organizational_unit' =>  '$.field[?(@._name=="cache-user-ous")].items.item',
=begin
        'publication_date' => { '$.field[?(@._name=="publication-date")].date'  => lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'online_publication_date' => { '$.field[?(@._name=="online-publication-date")].date'=> lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'acceptance_date' => { '$.field[?(@._name=="acceptance-date")].date'=> lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'filed_date' => { '$.field[?(@._name=="filed-date")].date' => lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'embargo_release_date' => { '$.field[?(@._name=="c-date-end-of-embargo")].date' => lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'start_date' => { '$.field[?(@._name=="start-date")].date' => lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } },
        'finish_date' => { '$.field[?(@._name=="finish-date")].date' => lambda { |d,o|
        DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
        } }
=end        
      'files' => { '$.files.file' => lambda { |d,o|
        d
      }},
      'files_supporting_information_desc' => { '$.files.file[?(@.description=="Supporting information")]' => lambda { |d,o|
        #pp "File with Supporting information in the description"
        #pp d
        d
      }},
      'files_public' => { '$.files.file[?(@.filePublic==true)]' => lambda { |d,o|
        d
      }},
      'files_public_false' => { '$.files.file[?(@.filePublic==false)]' => lambda { |d,o|
        d
      }},
      'files_intranet' => { '$.files.file[?(@.fileIntranet==true)]' => lambda { |d,o|
        d
      }},
      'files_intranet_false' => { '$.files.file[?(@.fileIntranet==false)]' => lambda { |d,o|
        d
      }}
    }
}

last_affected_when = '2023-04-01T00:00:00.0000+0100'
from_date = CGI.escape(DateTime.parse(last_affected_when).xmlschema)

pp "fromdate #{from_date}"

url = "#{config[:base_url]}#{ from_date  }"

url = "https://lirias2repo.kuleuven.be/elements-cache/rest/publications?per-page=50&affected-since=#{from_date}"
url_options = {user: config[:user], password: config[:password]}

DataCollector::Input.new( @logger )
one_record_output = DataCollector::Output.new
output = DataCollector::Output.new

fields = [
  "doi","isbn","issn","additional_identifier_with_http","other_identifier",
  "files","files_public","files_public_false","files_intranet","files_intranet_false","files_supporting_information_desc","record_with_files_and_doi",
  "is_open_access","open_access_status","accessright",
  "is_dataset","record_with_files_and_url_in_metadata"
]
results = {}
fields.each { |field| results[field] = [] }

counter = 0
nr_of_loops = 100

while url
  output.clear
  data = DataCollector::Input.new.from_uri(url,url_options)
  rules_ng.run( RULE_SET['rs_data'], data, output, {})
  output.data[:data] = [output.data[:data]] unless output.data[:data].is_a?(Array)
  
  output.data[:data].each do | data |
      results.keys.each do | field |
        results[field] << data["id"] if data.has_key?(field)
      end
  end

  rules_ng.run( RULE_SET['rs_metadata'], data, output, {})
  url = output.data[:metadata][:next_url].first

  counter += 1

  if counter >= nr_of_loops
    url = nil
  end

end

pp results

File.write('./test_output.json', JSON.dump(results))

