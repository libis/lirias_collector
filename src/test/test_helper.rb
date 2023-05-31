#encoding: UTF-8
$LOAD_PATH << '.' << '../lib' << "#{File.dirname(__FILE__)}" << "#{File.dirname(__FILE__)}/lib"
require 'core'
require "deepsort"

# require "unicode"
require "data_collector"
include DataCollector::Core
require "minitest/autorun"

ROOT_PATH = File.join( File.dirname(__FILE__), './')

RULES_PATH = "#{File.absolute_path(config[:rules_base])}/*.rb"

FIXTURES_PATH  = File.join( ROOT_PATH , "/fixtures")

Dir.glob(RULES_PATH).each do |file|
  file.gsub!(/.rb$/)
  require file
end


init_config = {
    :config_path => File.join(ROOT_PATH, '../config'),
    :config_file => "config.yml",
}

config = Collector::ConfigFile
config.path = init_config[:config_path]
config.file = init_config[:config_file]

RULE_SET = RULE_SET_v2_0 
 
def s2s(h) 
    if Array === h
      if h.size() == 1
        s2s(h[0])
      else
        h.map do |v| 
          s2s(v) 
        end 
      end
    elsif Hash === h 
      Hash[
        h.map do |k, v| 
          [k.respond_to?(:to_sym) ? k.to_sym : k, s2s(v)] 
        end 
      ]
    else
      h
    end
end
  
def get_data(lirias_id)
    url_options = {user: config[:user], password: config[:password]}
    data = DataCollector::Input.new.from_uri("https://lirias2repo.kuleuven.be/elements-cache/rest/publications/#{lirias_id}",url_options)
    unless data.nil?
      options = {
        :lirias_type_2_limo_type => LIRIAS_TYPE_2_LIMO_TYPE,
        :lirias_language => LIRIAS_LANGUAGE,
        :lirias_foramt_mean => FORMAT_MEAN,
        :prefixid => "",
      } 
      output = DataCollector::Output.new
  
      rules_ng.run( RULE_SET['rs_data'], data, output, options )
  
      data = s2s( output[:data] )
      data.slice(*FIELDS).compact.deep_sort!
    end
end
  
def get_esdata(lirias_id)
    url_options = {}

    fixtures_dir = FIXTURES_PATH
    file_name = File.join(fixtures_dir,"#{lirias_id}.json")

    if  File.exist?(file_name) 
        data = JSON.load(File.read(file_name))
    else
        pp "Download file from Elasticsearch"
        data = DataCollector::Input.new.from_uri("http://host.docker.internal:9201/libis-q-lirias/_doc/#{lirias_id}",url_options)
        if data.nil?
            raise "====> Error loading Elasticseach records ( id:#{lirias_id} )"
            return nil
        end
    
        data = data["_source"] 

        # function werd verwijderd. enkel roles wordt gebruikt
        persons_field=["first_author","creator","author"]
        persons_field.each do |field|
            if data[field].is_a?(Array)
                data[field].each do | f |
                    f.delete("function")
                end
            else
                data[field].delete("function")
            end
        end

        # personen bezitten nu altijd een name en pnx_display_name
        persons_field=["editor","supervisor","co_supervisor","translator"]
        persons_field.each do |field|
            unless data[field].nil?
                if data[field].is_a?(Array)
                    data[field].each do | f |
                        f["name"] = "#{f["last_name"]}, #{f["first_names"]}"
                        f["pnx_display_name"] = "#{f["name"]}$$Q#{f["name"]}"
                    end
                else
                    f = data[field]
                    f["name"] = "#{f["last_name"]}, #{f["first_names"]}"
                    f["pnx_display_name"] = "#{f["name"]}$$Q#{f["name"]}"
                end
            end
        end

        # embargo_release_date is no in format strftime("%Y-%m-%d")
        unless data["embargo_release_date"].nil?
            data["embargo_release_date"] = "#{data["embargo_release_date"][0]["year"]}-#{data["embargo_release_date"][0]["month"]}-#{data["embargo_release_date"][0]["day"]}"
        end

        File.open(file_name, 'wb') do |f|
            f.puts data.to_json
        end
    end
    
    #pp "$------------------------------>"
    #pp data["relationship"]
    unless data["relationship"].nil?
      
      data["relationship"].each { |relation, direction| 
        #pp direction
        direction.each { |dd,dv|
          #pp dv
          dv = [dv] unless dv.is_a?(Array)
          dv.map! { |v|  
            v.slice("id")  
          }
        }
      }
    end

  
    #pp data["relationship"]
    #pp "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    data =  s2s( data )
    data.slice(*FIELDS).compact.deep_sort!
  
end
  
def show_for_debug(data,es_data,field)
    puts "=== DEBUGGING for [#{field}] ===="
    data_field = process_field( data[field] )
    es_data_field = process_field( es_data[field] )

    pp "data_field == es_data_field : #{data_field == es_data_field}"
    
    if data_field == es_data_field
        # puts "data and es_data are equal"    
        # pp data_field
    else        
        puts "\n\n"
        puts "-- DATA -- "
        # pp data.keys
        pp data_field
        puts "---ES DATA -- "
        pp es_data_field
        puts "----------------------------------------\n"
    end   
end
  
def process_field(data)
    if data.nil?
        return ""
    end
    if data.is_a?(String)
        return data.delete(' ')
    end
end

LIRIAS_TYPE_2_LIMO_TYPE = {
    "presentation"         => { :limo => "other", :ris => "ABS" },
    "book"                 => { :limo => "book", :ris => "BOOK"},
    "chapter"              => { :limo => "book_chapter", :ris => "CHAP" },
    "c-bookreview"         => { :limo => "review", :ris => "GEN" },
    "conference"           => { :limo => "conference_proceeding", :ris => "CONF" },
    "design"               => { :limo => "design", :ris => "ART" },
    "dataset"              => { :limo => "research_dataset", :ris => "DATA" },
    "c-editedbook"         => { :limo => "book", :ris => "EDBOOK" },
    "internet-publication" => { :limo => "other", :ris => "WEB" },
    "c-presentation"       => { :limo => "other", :ris => "GEN" },
    "journal-article"      => { :limo => "article", :ris => "JOUR" },
    "other"                => { :limo => "other", :ris => "GEN" },
    "patent"               => { :limo => "patent", :ris => "PAT" },
    "thesis-dissertation"  => { :limo => "dissertation", :ris => "THES" },
    "report"               => { :limo => "text_resource", :ris => "RPRT" },
    "media"                => { :limo => "text_resource", :ris => "GEN" },
    "software"             => { :limo => "other", :ris => "COMP" },
    "c-book"               => { :limo => "text_resource", :ris => "GEN" }
}

LIRIAS_LANGUAGE = {
    "dutch"      => "dut",
    "english"    => "eng",
    "french"     => "fre",
    "nederlands" => "dut",
    "spanish"    => "spa",
    "nl"         => "dut",
    "en_us"      => "eng",
    "eng"        => "eng",
    "en"         => "eng",
    "fr"         => "fre",
    "hungarian"  => "hun",
    "swedish"    => "swe",
    "hebrew"     => "heb",
    "konkani"    => "kok",
    "estonian"   => "est",
    "filipino"   => "fil",
    "pilipino"   => "fil",
    "finnish"    => "fin",
    "bengali"    => "ben",
    "icelandic"  => "ice",
    "romanian"   => "rum",
    "moldovan"   => "rum",
    "moldavian"  => "rum",
    "polish"     => "pol",
    "czech"      => "cze",
    "korean"     => "kor",
    "turkish"    => "tur",
    "norwegian"  => "nor",
    "georgian"   => "geo",
    "danish"     => "dan",
    "arabic"     => "ara",
    "russian"    => "rus",
    "portuguese" => "por",
    "german"     => "ger",
    "italian"    => "ita",
    "catalan"    => "cat",
    "greek"      => "gre",
    "persian"    => "per",
    "uzbek"      => "uzb",
    "ukrainian"  => "ukr",
    "armenian"   => "arm",
    "latin"      => "lat",
    "latvian"    => "lav",
    "chinese"    => "chi",
    "castilian"  => "spa",
    "japanese"   => "jpn",
    "afrikaans"  => "afr",
    "croatian"   => "hrv",
    "slovak"     => "slo",
    "bulgarian"  => "bul",
    "slovenian"  => "slv"
}

FORMAT_MEAN = {
    "archival_material" => "archival_materials",
    "archival_material_manuscript" => "archival_material_manuscripts",
    "edited_book" => "edited_books",
    "newspaper" => "newspapers",
    "computer_file" => "computer_files",
    "journalissue" => "journalissues",
    "offprint" => "articles",
    "patent" => "patents",
    "text_resource" => "text_resources",
    "article" => "articles",
    "other" => "other",
    "journal" => "journals",
    "image" => "images",
    "score" => "scores",
    "audio" => "audios",
    "web_resource" => "web_resources",
    "book" => "books",
    "review" => "reviews",
    "book_chapter" => "book_chapters",
    "internal_report" => "internal_reports",
    "audio-visual" => "audio_visual",
    "conference" => "conferences",
    "chapter" => "book_chapters",
    "game" => "games",
    "standard" => "standards",
    "schoolbook" => "schoolbooks",
    "manuscript" => "manuscripts",
    "external_report" => "external_reports",
    "legal_document" => "legal_documents",
    "video" => "videos",
    "map" => "maps",
    "database" => "databases",
    "statistical_data_set" => "statistical_data_sets",
    "conference_proceeding" => "conference_proceedings",
    "dissertation" => "dissertations",
    "reference_entry" => "reference_entrys",
    "rare_book" => "rare_books",
    "newspaper_article" => "newspaper_articles",
    "government_document" => "government_documents",
    "collection" => "collections",
    "dataset" => "datasets",
    "microform" => "microform"
  }

  
FIELDS = [:id, 
    :identifiers,
    :doi,
    :relationship,
    :keywords,
    #:dspace_keywords,
    :virtual_collections,
    :abstract,
    :pagination,
    :volume,
    :issue,
    :parent_title,
    :peer_reviewed,
    :historic_collection,
    :funding_acknowledgements,
    :journal,
    :publication_status,
    :professional_oriented,
    :language,
    :note,
    :oa,
    :event,
    :format,
    :medium,
    :accessright,
    :edition,
    :place_of_publication,
    :other_identifier_type,
    :external_identifiers,
    :vabb_type,
    :vabb_identifier,
    :ispartof,
    :facets_toplevel,
    :publication_date,
    :acceptance_date,
    :pii,
    :organizational_unit,
    :embargo_release_date,
    :isPartOf,
    # :book_title,
    :article_title,
    :relation,
    :serie,
    :vertitle,
    :notes,
    :local_field_11,
    :event,
    :local_field_02,
    :invitedby,
    :organizational_unit,
    :author,
    :editor,
    :contributors,
    :translator,
    :public_url,
    :delivery_fulltext,
    :linktorsrc,
    :delivery_delcategory
  ]
  