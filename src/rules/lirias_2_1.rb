#encoding: UTF-8
require 'data_collector'

include DataCollector::Core

#require 'iso639'
DEBUG=config[:debugging]
LOG_LIRIAS_RECORDID=config[:log_recordids]

PERFORMANCE_DEBUG=false

RULE_SET_v2_1 = {
  'version' => "2.1",
  'rs_metadata' => {
    'metadata' => { '@' => lambda { |d,o| 
      out = DataCollector::Output.new
      pp 'rs_this_url' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_this_url'], d, out, o)
      pp 'rs_next_url' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_next_url'], d, out, o)
      pp 'rs_affected_date' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_affected_date'], d, out, o)
      pp 'rs_deleted_when' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_deleted_when'], d, out, o)
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

        pp "DELETED OBJECT ID [lirias_recordid]: #{d['deleted_object']['_id']}" if LOG_LIRIAS_RECORDID

        rdata = { 
          :source                 => "lirias",
          :sourceid               => "lirias",
          :id                     => d['deleted_object']['_id'],
          :sourcerecordid         => d['deleted_object']['_id'],
          :deleted_when           => d['deleted_object']['_deleted_when'],
          :deleted                => d['deleted_object']['_deleted_when'],
          :title                  => d['title']
        }.with_indifferent_access
       

        rdata[:recordid] = rdata[:sourceid] + rdata[:id]

        return rdata
      end

      timing_start = Time.now

      start_process  = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z") 
      pp "OBJECT ID [lirias_recordid]: #{d['object']['_id']}"  if LOG_LIRIAS_RECORDID 
#      if ["712458","431535"].include?(d['object']['_id'])
#        pp ":last_run_updates: '2023-01-12T18:03:57.6+01:00'"
#        pp "=====================================================================================================>>>>>"
#        pp "OBJECT ID [lirias_recordid]: #{d['object']['_id']}"
#        pp "=====================================================================================================>>>>>"
#      end

      rdata = { 
        :source                 => "lirias",
        :sourceid               => "lirias",
        :id                     => d['object']['_id'],
        :sourcerecordid         => d['object']['_id'],
        :lirias_type            => d['object']['_type'],
        :updated                => d['object']['_last_affected_when'],
        :elements_creation_date => d['object']['_created_when'],
        :claimed                => d['object']['claimed'],
        :facets_creator_contributor => [],
        :identifiers             => []
      }.with_indifferent_access
            
      rdata[:recordid] = rdata[:sourceid] + rdata[:id]

      o[:recordid] = rdata[:recordid]

      if rdata[:claimed]&.to_s == "false"
        rdata[:deleted] = d['object']['_last_affected_when']
        return rdata
      end
           
      #####   special/additional transformation  #######
      pp 'special/additional transformation parsing data' if DEBUG
      rdata[:type]    = o[:lirias_type_2_limo_type][ rdata[:lirias_type] ].nil? ? "other" : o[:lirias_type_2_limo_type][ rdata[:lirias_type] ][:limo]
      rdata[:ristype] = o[:lirias_type_2_limo_type][ rdata[:lirias_type] ].nil? ? "GEN" : o[:lirias_type_2_limo_type][ rdata[:lirias_type] ][:ris]
      rdata[:facets_rsrctype] = rdata[:facets_prefilter] =  o[:lirias_format_mean][ rdata[:type].downcase ] ||  rdata[:type]

      o[:type]        = rdata[:type] 


      timing_start = Time.now 
      merged_record = DataCollector::Output.new
      pp ("Create DataCollector::Output.new #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_merged_record' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_merged_record'], d, merged_record, o)
      pp ("parsing rs_merged_record #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      rdata.merge!(merged_record.data[:record].to_h)
      pp ("parsing rdata.merge #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      out_1 = DataCollector::Output.new
      pp 'rs_keyword' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_keyword'], d, out_1, o)

      pp 'rs_ids' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_ids'], d, out_1, o)

      timing_start = Time.now 
      pp 'rs_relationships' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_relationships'], d, out_1, o)
      pp ("parsing rs_relationships #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG
      
      rdata.merge!(out_1.data.to_h)

      out = DataCollector::Output.new
      
      pp 'identifiers concat' if DEBUG
      rdata[:identifiers].concat( rdata[:pmid].map { |i| "$$CPMID:$$V" + i } ) if rdata[:pmid].is_a?(Array)
      rdata[:identifiers].concat( rdata[:scopusid].map { |i| "$$CSCOPUSID:$$V" + i } ) if rdata[:scopusid].is_a?(Array)

      # WOS-ID https://libis.teamwork.com/app/tasks/20947956 ( Web of Science  terms of use)
      # rdata[:identifiers].concat( rdata[:wosid] ) if rdata[:wosid].is_a?(Array)

      rdata[:subject] = rdata[:keyword]&.uniq
      pp 'special/additional transformation language' if DEBUG

      rdata[:language]&.map! { |t| o[:lirias_language][t.downcase] || t }

      pp 'special/additional transformation creator' if DEBUG

      rdata[:creator] = rdata[:author] 

      pp 'special/additional c-editedbook' if DEBUG
      if  rdata[:lirias_type] == "c-editedbook"
        contribuors_roles_sort_order = ["Editor"]
        if rdata[:contributor].is_a?(Array)
          rdata[:contributor].sort_by! { |c| c[:roles]&.map{ |cr| contribuors_roles_sort_order.index( cr ) || Float::INFINITY }&.min() || Float::INFINITY }
        end
      end

      #if  rdata[:lirias_type] == "design"
      #  contribuors_roles_sort_order = ["Writer", "Editor", "Curator", "Tranlator","Architect"]
      #  rdata[:contributor].sort_by! { |c| c[:roles]&.map{ |cr| contribuors_roles_sort_order.index( cr) || Float::INFINITY }&.min() || Float::INFINITY }
      #end
      
      pp 'special/additional medium' if DEBUG

      rdata[:medium]&.uniq!

      unless rdata[:medium].nil?
        if rdata[:number_of_pages].nil?
          rdata[:format] = rdata[:medium]
        else
          rdata[:format] = rdata[:medium].map { |m| m + " page(s): " + rdata[:number_of_pages].uniq.join(', ')  }
        end
      end

      pp 'special/additional transformation facets_creator_contributor' if DEBUG
      rdata[:facets_creator_contributor] << rdata[:creator] unless rdata[:creator].nil?
      rdata[:facets_creator_contributor] << rdata[:contributor] unless rdata[:contributor].nil?

      rdata[:facets_creator_contributor].flatten!&.compact!

      rdata[:facets_staffnr] = rdata[:facets_creator_contributor].clone
      
      rdata[:facets_creator_contributor].map!{ |p| [ p[:name], Array.wrap(p[:identifiers]).map{ |s| [s[:staff_nbr], s[:old_staff_nbr]] } ] }.flatten!&.compact!

      # pp rdata[:facets_creator_contributor]

      pp 'special/additional transformation facets_staffnr' if DEBUG

      #rdata[:facets_staffnr].map!{ |p| Array.wrap(p[:identifiers]).select{ |i| i[:staff_nbr] }.map!{ |p| "staffnr_#{p[:staff_nbr]}" }  }.flatten!&.compact!

      #rdata[:facets_staffnr].map!{ |p| Array.wrap(p[:identifiers]).map!{ |i| [ i[:staff_nbr], i[:old_staff_nbr] ] } }.flatten!&.compact!&.map!{ |p| "staffnr_#{p}" } 
      rdata[:facets_staffnr].map!{ |p| Array.wrap(p[:identifiers]).select{ |i| (i[:staff_nbr] || i[:old_staff_nbr] )}.map!{ |p| "staffnr_#{ p[:staff_nbr] || p[:old_staff_nbr] }" }  }.flatten!&.compact!
      # pp rdata[:facets_staffnr]

      rdata[:local_field_07] = rdata[:lirias_type]  

      rdata[:local_field_10] = []
      
      rdata[:virtual_collections] = rdata[:virtual_collections]&.uniq
      rdata[:local_field_10].concat rdata[:virtual_collections] unless rdata[:virtual_collections].nil?
      
      rdata[:dspace_keywords] = rdata[:dspace_keywords].uniq unless rdata[:dspace_keywords].nil?
      

      rdata[:local_facet_10] = rdata[:local_field_10].clone()
      rdata[:local_facet_10].concat  rdata[:organizational_unit] unless rdata[:organizational_unit].nil?

      pp 'special/additional transformation article_title' if DEBUG

      if ["chapter","book_chapter","journal-article","article","conference","conference_proceeding"].include?( rdata[:type] )
        rdata[:article_title] = rdata[:title]
      else
        rdata[:book_title] = rdata[:title].clone()
        rdata[:book_title].concat rdata[:parent_title] unless rdata[:parent_title].nil?

      end
      # performance debugging 

      pp 'parsing data DONE' if DEBUG
      rdata.compact!

      rdata

    } }
  },
  'rs_merged_record' => {
    'record' => {'$.object.records.record[?(@._source_name=="merged")].native' => lambda { |d,o|

      total_time = Time.now


      timing_start = Time.now
      out = DataCollector::Output.new
      pp 'rs_record' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_record'], d, out, o)
      pp ("parsing rs_record #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_creator' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_creator'], d, out, o)
      
      unless out.data[:author].nil?
        if out.data[:author].is_a?(Array)
          out.data[:first_author] = out.data[:author].first
        else
          out.data[:first_author] = out.data[:author]
        end
      end
   
      # De manier waarop de verschillende auteurs functies en credit roles worden
      # in gevoerd is niet eenduidig. Daarom wordt de "contributor" nog eens extra 
      # aangevuld met persons en/of roles
      # :editor, :supervisor, :co_supervisor, :translator hebben 
      # die specifieke role niet in de property role (dit zou verdubbeling zijn van info)
      # Deze property role wordt toegevoegd als ze aan contributor worden toegevoegd.
      
      include_in_contributors=[:editor, :supervisor, :co_supervisor, :translator]
      key_properties = [:last_name, :first_names, :initials]
      contributors = {}

      pp 'include_in_contributors' if DEBUG 
      out.data[:contributor] = [ out.data[:contributor] ] unless out.data[:contributor].is_a?(Array)
      out.data[:contributor].each do |contributor|
        unless contributor.nil?
          k = contributor.values_at(*key_properties).join("_")
          contributors[ k ] = contributor
        end
      end

      include_in_contributors.each do |author_type|
        if out.data[author_type]

          authors_of_type = out.data[author_type].is_a?(Array) ? out.data[author_type] : [ out.data[author_type] ]

          authors_of_type.each do |aot|
            author_of_type = aot.clone
            if author_of_type[:roles].nil?
              author_of_type[:roles] = [author_type.to_s.capitalize() ]
            else
              author_of_type[:roles].union( [author_type.to_s.capitalize()] )
            end

            k = author_of_type.values_at(*key_properties).join("_")
            if contributors[k].nil?
              contributors[k] = author_of_type
            else
              
              if contributors[k][:roles].nil?
                contributors[k][:roles] = author_of_type[:roles]
              else
                contributors[k][:roles].union( author_of_type[:roles] )
              end
              contributors[k].merge!(author_of_type)
            end

            person = DataCollector::Output.new
            pp 'rs_person_display_name' if DEBUG
            rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], author_of_type, person, o)
            contributors[k][:pnx_display_name] = person.data[:pnx_display_name]
            contributors[k][:display_name] = person.data[:display_name]

          end
        end
        
      end


      
      pp 'author_type contributors.values:' if DEBUG 
#      pp contributors.values.size
#      pp contributors.values

      out.data[:contributor] = contributors.values

# Nog geen out.data[:version] gevonden
#      unless out.data[:edition].nil? && out.data[:version].nil?
#        if out.data[:parent_title].nil? && out.data[:journal].nil?
#          if out.data[:edition].nil?
#            out.data[:edition] = out.data[:version]
#          else
#            out.data[:edition].push ( out.data[:version] ) unless out.data[:version].nil?
#          end
#        else
#          out.data[:edition] = nil
#        end
#      end
      pp ("parsing rs_creator #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_files' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_files'], d, out, o)
      pp ("parsing rs_files #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_identifiers' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_identifiers'], out.data, out, o)
      unless out.data[:place_of_publication].nil?
        out.data[:publisher].map! { |p| p + "; " +  out.data[:place_of_publication].uniq.join(', ') } unless out.data[:publisher].nil?
      end
      pp ("parsing rs_identifiers #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      unless out.data[:format].nil? ||  out.data[:number_of_pages].nil?
        out.data[:format] = [out.data[:format]].flatten&.map { |m| m + " page(s): " + out.data[:number_of_pages].uniq.join(', ')  }
      end

      timing_start = Time.now
      pp 'rs_search_creationdate' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_search_creationdate'], out.data, out, o)
      pp ("parsing rs_search_creationdate #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_creationdate' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_creationdate'], out.data, out, o)
      pp ("parsing rs_creationdate #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      pp 'titles' if DEBUG
      out.data[:book_title] = out.data[:parent_title] 
      out.data[:journal_title] = out.data[:journal]
      out.data[:vertitle] = out.data[:alternative_title]

    #  if out.data[:parent_title].nil? && out.data[:journal].nil?
    #    out.data[:edition] = nil
    #  end
      
      unless out.data[:abstract].nil?
        #  data = data.gsub /&lt;/, '&lt; /' => https://github.com/mehmetc/data_collector/ ?????
        out.data[:description] = out.data[:abstract].map!{ |a| a.gsub /< \//, '<' }
      end
      
      
      out.data[:notes]          = out.data[:funding_acknowledgements]
      out.data[:local_field_11] = out.data[:funding_acknowledgements]

      pp 'relation' if DEBUG
      out.data[:relation] = out.data[:serie]

      unless out.data[:relation].nil?
        out.data[:relation].map! { |e| e.strip + ", Date: " + out.data[:start_date].uniq.join(', ').gsub(/-/, '/') } unless out.data[:start_date].nil?
        out.data[:relation].map! { |e| e.strip + " - " + out.data[:finish_date].uniq.join(', ').gsub(/-/, '/') } unless out.data[:finish_date].nil?
        out.data[:relation].map! { |e| e.strip + ", Location: " + out.data[:location].uniq.join } unless out.data[:location].nil?
      end
      pp 'event' if DEBUG
      out.data[:event] = out.data[:name_of_conference].clone
      unless out.data[:event].nil?
        out.data[:event].map! { |e| e.strip + ", Date: " + out.data[:start_date].uniq.join(', ').gsub(/-/, '/') } unless out.data[:start_date].nil?
        out.data[:event].map! { |e| e.strip + " - " + out.data[:finish_date].uniq.join(', ').gsub(/-/, '/') } unless out.data[:finish_date].nil?
        out.data[:event].map! { |e| e.strip + ", Location: " + out.data[:location].uniq.join } unless out.data[:location].nil?
        out.data[:event].map! { |e| e.strip + ", " + out.data[:venue_designart].uniq.join(', ') } unless out.data[:venue_designart].nil?
      end

      pp 'local_fields' if DEBUG
      out.data[:local_field_02] = out.data[:event]

      out.data[:local_field_08] = out.data[:publication_status].nil? ? out.data[:patent_status] : out.data[:publication_status]

      out.data[:local_field_09] = out.data[:invitedby] 

      timing_start = Time.now
      pp 'rs_ispartof' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_ispartof'], out.data, out, o)
      pp ("parsing rs_open_access #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      pp 'backlink' if DEBUG
      out.data[:backlink] = out.data[:public_url].map { |u|
        unless u.match(/\/bitstream\/|\/retrieve\//)
          "$$U#{u}$$Ebacklink_lirias"
        end
      }

      timing_start = Time.now
      pp 'rs_open_access' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_open_access'], out.data, out, o)
      pp ("parsing rs_open_access #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_delivery' if DEBUG
      # no files, issn or isbn for research_dataset
      rules_ng.run(RULE_SET_v2_1['rs_delivery'], out.data, out, o)
      pp ("parsing rs_delivery #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      timing_start = Time.now
      pp 'rs_facets_toplevel' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_facets_toplevel'], out.data, out, o)
      pp ("parsing rs_facets_toplevel #{((Time.now - timing_start) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      pp ("parsing total_time #{((Time.now - total_time) * 1000).to_i} ms") if PERFORMANCE_DEBUG

      out.data
    } }
  },
  'rs_record' => {
    title: '$.field[?(@._name=="title")].text',
    alternative_title: '$.field[?(@._name=="c-alttitle")].text',
    serie: '$.field[?(@._name=="series")].text',
    book_serie: '$.field[?(@._name=="c-series-editor")].text',
    edition: '$.field[?(@._name=="edition")].text',
    volume: '$.field[?(@._name=="volume")].text',
    issue: '$.field[?(@._name=="issue")].text',
    medium: '$.field[?(@._name=="medium")].text',

    pagination: '$.field[?(@._name=="pagination")][?( @._display_name==( "Pagination" || "Number of pages") )].pagination',
    number_of_pages: '$.field[?(@._name=="pagination")][?( @._display_name==( "Pagination" || "Number of pages") )].pagination.page_count',
   
    publisher: '$.field[?(@._name=="publisher")].text',
    publisher_url: '$.field[?(@._name=="publisher-url")].text',
    place_of_publication: '$.field[?(@._name=="place-of-publication")].text',
   
    isbn_10: '$.field[?(@._name=="isbn-10")].text',
    isbn_13: '$.field[?(@._name=="isbn-13")].text',
    doi: '$.field[?(@._name=="doi")].text',
    
    eissn: '$.field[?(@._name=="eissn")].text',
    external_identifiers: { '$.field[?(@._name=="external-identifiers")].identifiers.identifier' => lambda { |d,o| d["$text"] } },

    other_identifier: '$.field[?(@._name=="c-identifier-other"].text',
    other_identifier_type: '$.field[?(@._name=="c-identifierother-type")].text',

    other_identifiers_handle: '$.field[?(@._name=="c-identifier-other" && @._type="handle")].text',
    other_identifiers_url: '$.field[?(@._name=="c-identifier-other" && @._type="url")].text',
    other_identifiers_urn: '$.field[?(@._name=="c-identifier-other" && @._type="urn")].text',
    other_identifiers_purl: '$.field[?(@._name=="c-identifier-other" && @._type=purl")].text',
    other_identifiers_ark: '$.field[?(@._name=="c-identifier-other" && @._type="ark")].text',

    additional_identifier: '$.field[?(@._name=="c-additional-identifier")].items.item',

    is_open_access: '$.field[?(@._name=="is-open-access")].boolean',
    open_access_status: '$.field[?(@._name=="open-access-status")].text',

    abstract: '$.field[?(@._name=="abstract")].text',
    author_url: '$.field[?(@._name=="author-url")].text',
    
    publication_status: '$.field[?(@._name=="publication-status")].text',
    note: '$.field[?(@._name=="notes")].text',
    numbers: '$.field[?(@._name=="numbers")].text',
    chapter_number: '$.field[?(@._display_name=="Chapter number")].text',
    abstract_number: '$.field[?(@._display_name=="Abstract number")].text',
    report_number: '$.field[?(@._display_name=="Report number")].text',
    paper_number: '$.field[?(@._display_name=="Paper number")].text',
    article_number: '$.field[?(@._display_name=="Article number")].text',
  
    parent_title: '$.field[?(@._name=="parent-title")].text',
    name_of_conference: '$.field[?(@._name=="name-of-conference")].text',
    location: '$.field[?(@._name=="location")].text',

    journal: '$.field[?(@._name=="journal")].text',
    issn: '$.field[?(@._name=="issn")].text',
    pii: '$.field[?(@._name=="pii")].text',
    language: '$.field[?(@._name=="language")].text',
    patent_number: '$.field[?(@._name=="patent-number")].text',

    patent_status: '$.field[?(@._name=="patent-status")].text',
    commissioning_body: '$.field[?(@._name=="commissioning-body")].text',

    peer_reviewed: '$.field[?(@._name=="c-peer-review")].text',
    invitedby: '$.field[?(@._name=="c-invitedby")].text',
    
    funding_acknowledgements: '$.field[?(@._name=="funding-acknowledgements")].funding_acknowledgements.acknowledgement_text',
    vabb_type: '$.field[?(@._name=="c-vabb-type")].text',
    vabb_identifier: '$.field[?(@._name=="c-vabb-identifier")].text',
    historic_collection: '$.field[?(@._name=="c-collections-historic")].items.item',

    public_url: '$.field[?(@._name=="public-url")].text',

    professional_oriented: { '$.field[?(@._name=="c-professional")].boolean' => lambda { |d,o| d.to_s } },
    confidential: { '$.field[?(@._name=="confidential")].boolean' => lambda { |d,o| d.to_s } },
    number_of_pieces: { '$.field[?(@._name=="number-of-pieces")].boolean' => lambda { |d,o| d.to_s } },
    version: { '$.field[?(@._name=="version")].boolean' => lambda { |d,o| d.to_s } },

    accessright:  '$.field[?(@._name=="c-accessrights")].text',
    venue_designart:  '$.field[?(@._name=="c-venue-designart")].items.item',
    organizational_unit:  '$.field[?(@._name=="cache-user-ous")].items.item',

    publication_date: { '$.field[?(@._name=="publication-date")].date'  => lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    online_publication_date: { '$.field[?(@._name=="online-publication-date")].date'=> lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    acceptance_date: { '$.field[?(@._name=="acceptance-date")].date'=> lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    filed_date: { '$.field[?(@._name=="filed-date")].date' => lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    embargo_release_date: { '$.field[?(@._name=="c-date-end-of-embargo")].date' => lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    start_date: { '$.field[?(@._name=="start-date")].date' => lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },
    finish_date: { '$.field[?(@._name=="finish-date")].date' => lambda { |d,o|
      DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
    } },

##  ===> collections ??? availability ??? BOF ??? (lirias977104)

    #'professional_oriented' => '$.field[?(@._name=="c-professional")].boolean').map(&:to_s)
    #'confidential' => '$.field[?(@._name=="confidential")].boolean').map(&:to_s)
    #'number_of_pieces' => '$.field[?(@._name=="number-of-pieces")].boolean').map(&:to_s)
    #'version' => '$.field[?(@._name=="version")].boolean').map(&:to_s)

##### => ALS ER MAAR 1 bestand is en dit heeft geen label dat zelf een label plaatsen "Link to resource of zoiets"
#### en een file eerst open url via ISSN, of ISBN DOI

  },


# <api:field name="authors"         display-name="Authors" type="person-list">
# <api:field name="c-contributor"   display-name="Contributors" type="person-list">
# <api:field name="editors"         display-name="Supervisor" type="person-list"> (1822382)
# <api:field name="editors"         display-name="Editors" type="person-list">  (1769877 or 1815226 => wordt NIET herhaald met roles in c-contributor)
# <api:field name="c-editor"        display-name="Editor" type="person-list"> (1685129 => wordt herhaald met role Editor in c-contributor)
# <api:field name="c-cosupervisor"  display-name="Co-Supervisor" type="person-list">
# <api:field name="c-translator"    display-name="Translator" type="person-list"> (1815226)
# <api:field name="c-series-editor" display-name="Book series editors" type="person-list"> (1815226)

  'rs_creator' => {
    author: {'$.field[?(@._name=="authors")].people.person' => lambda { |d,o|
      pp 'rs_creator author' if DEBUG
      out = DataCollector::Output.new
      pp 'rs_creator author rs_person' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      pp 'rs_creator author rs_person_display_name' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
    editor: {'$.field[?(@._name=="editors")][?(@._display_name=="Editors")].people.person' => lambda { |d,o|
      pp 'rs_creator editor' if DEBUG
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
    translator: {'$.field[?(@._name=="c-translator")][?(@._display_name=="Translator")].people.person' => lambda { |d,o|
      pp 'rs_creator translator' if DEBUG
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
    supervisor: {'$.field[?(@._name=="editors")][?(@._display_name=="Supervisor")].people.person' => lambda { |d,o|
      pp 'rs_creator supervisor' if DEBUG
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
    co_supervisor: {'$.field[?(@._name=="c-cosupervisor")].people.person' => lambda { |d,o|
      pp 'rs_creator co_supervisor' if DEBUG
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
    book_series_editor: {'$.field[?(@._name=="c-series-editor")].people.person' => lambda { |d,o|
      pp 'rs_creator book_series_editor' if DEBUG
      o['role'] = "Book series editor"
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } },
## Na verwerking van contributers noodzakelijk om editors, translators, .... toe te voegen
    contributor: {'$.field[?(@._name=="c-contributor")].people.person' => lambda { |d,o|
      pp 'rs_creator contributor' if DEBUG
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
      rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
      out.data
    } }


=begin
# werkt niet. enkele de laatste wordt opgenomen in de array
    'contributor' => [
      {'$.field[?(@._name=="c-contributor")].people.person' => lambda { |d,o|
        pp 'rs_creator contributor' if DEBUG
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
        rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
        out.data
      } },
      {'$.field[?(@._name=="editors")][?(@._display_name=="Editors")].people.person' => lambda { |d,o|
        pp 'rs_creator contributor Editor' if DEBUG
        o['role'] = "Editor"
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
        rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
        out.data
      } },
      {'$.field[?(@._name=="c-translator")][?(@._display_name=="Translator")].people.person' => lambda { |d,o|
        pp 'rs_creator contributor Translator' if DEBUG
        o['role'] = "Translator"
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
        rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
        out.data
      } },
      {'$.field[?(@._name=="c-cosupervisor")].people.person' => lambda { |d,o|
        pp 'rs_creator contributor Co supervisor' if DEBUG
        o['role'] = "Co supervisor"
        pp d
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
        rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
        pp out.data
        out.data
      } },
      {'$.field[?(@._name=="editors")][?(@._display_name=="Supervisor")].people.person' => lambda { |d,o|
        pp 'rs_creator contributor Supervisor' if DEBUG
        o['role'] = "Supervisor"
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person'], d, out, o)
        rules_ng.run(RULE_SET_v2_1['rs_person_display_name'], out.data, out, o)
        pp out.data
        out.data
      } }
    ]
=end
  },

  # ########################################################################################
  #
  # om zetten van identifiers naar link verloopt nu via de central-package 
  # https://github.com/libis/PrimoVE-dev_env/blob/98e1e4cacd6f2b504da961cbd0d1724c1b30ebd2/src/components/details/externalLink/createLinks.js
  #
  # ########################################################################################

  'rs_person' => {
    identifiers: [
      { '$.identifiers' => lambda { |d,o|
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person_identifiers'], d, out, o)
        out.data[:identifiers]
      } } ,
      { '$'  => lambda { |d,o|
        if ! d['username'].nil?
          if d['is_current_staff'].to_s == "true" 
            { 'staff_nbr'.to_sym => d['username'] }
          else
            { 'old_staff_nbr'.to_sym => d['username'] }
          end
        end
      } } 
    ],
    roles: [
      { '@' => lambda { |d,o| o['role'] }},
      { '$.roles.role' => lambda { |d,o|  
        if d.is_a?(Hash)
          d = nil
        end
        d 
      }},
      { '$.roles.role.$text' => lambda { |d,o| d }}
    ],
=begin
# funtion werd vervangen door roles
    'function' =>  [
      { '@' => lambda { |d,o| o['role'] }},
      { '$.roles.role' => lambda { |d,o|  
        if d.is_a?(Hash)
          d = nil
        end
        d 
      }},
      { '$.roles.role.$text' => lambda { |d,o| d }}
    ],
=end
#   username:    $.username',
    last_name:   '$.last_name',
    first_names: '$.first_names',
    initials:    '$.initials',
    name:        { '@' => lambda { |d,o|  "#{d["last_name"]}, #{d["first_names"]}" } },
  },
  'rs_person_display_name' => {
    pnx_display_name: { '$'  => lambda { |d,o|
      roles = ""
      name = [d[:last_name]&.first, d[:first_names]&.first].join(", ")
      unless d[:roles].nil?
        roles = " (#{ d[:roles].join(', ') })"
      end
      "#{name}#{roles}$$Q#{name}"
    } },
    display_name: { '$'  => lambda { |d,o|
      roles = ""
      name = [d[:last_name]&.first, d[:first_names]&.first].join(", ")
      unless d[:roles].nil?
        roles = " (#{ d[:roles].join(', ') })"
      end
      "#{name}#{roles}"
    } }
  },
  'rs_person_identifiers' => {
    identifiers: { '@' => lambda { |d,o|
      if d['identifier']
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_person_identifiers_identifer'], d['identifier'], out, o)
        r = out.data[:identifier]
      else
        pp "====================>>>>>>>>>> rs_person_identifiers #{d} ?????"
        r ={ 'staff_nbr'.to_sym => d }
      end
      r
    } }
  },
  'rs_person_identifiers_identifer' => {
    identifier: { '@' => lambda { |d,o|
      { d['_scheme'].to_sym => d['$text']}
    } }
  },
  'rs_keyword' => {
    keyword: {'$.object.all_labels[?(@._type=="keyword-list")].keywords.keyword' => lambda { |d,o|
      if d.is_a?(Hash) && d["_scheme"] != "c-virtual-collection" 
        d['$text']
      end
} },
    virtual_collections: {'$.object.all_labels[?(@._type=="keyword-list")].keywords.keyword[?(@._scheme=="c-virtual-collection")]' => lambda { |d,o|
      d['$text']
    } },    
    dspace_keywords: {'$.object.all_labels[?(@._type=="keyword-list")].keywords.keyword[?(@._source=="dspace")]' => lambda { |d,o|
      if d.is_a?(Hash) && d['_scheme'] != 'c-virtual-collection'
        d['$text']
      end
    } }
  },
  'rs_ids' => {
    pmid:     {'$.object.records.record[?(@._source_name=="pubmed")]._id_at_source' => lambda { |d,o| d } },
    wosid:    {'$.object.records.record[?(@._source_name=="wos")]._id_at_source' => lambda { |d,o| d } },
    scopusid: {'$.object.records.record[?(@._source_name=="scopus")]._id_at_source'  => lambda { |d,o| d }}
  },
  'rs_relationships' => {
    relationship: {'$.object.relationships' => lambda { |d,o|
      unless d.nil?
        rdata = {
          :correction => [],
          :derivative => [],
          :supplement => [],
          :supersedes => []

        }
        corrections = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_correction'], d, corrections, o)
        rdata[:correction] = corrections.data
        
        derivatives = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_derivative'], d, derivatives, o)
        rdata[:derivative] = derivatives.data
   
        supplements = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_supplement'], d, supplements, o)
        rdata[:supplement] = supplements.data
        
        supersedes = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_supersedes'], d, supersedes, o)
        rdata[:supersedes] = supersedes.data
        
        rdata.delete_if { |k, v| v.empty? }

        if rdata.empty?
          rdata = nil
        end
      end
      rdata

    } }
  },
  'rs_correction' => {
    to: { '$.relationship[?(@._type=="publication-publication-correction")].related[?(@._direction=="to")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } },
    from: { '$.relationship[?(@._type=="publication-publication-correction")].related[?(@._direction=="from")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } }
  },
  'rs_derivative' => { 
    to: { '$.relationship[?(@._type=="publication-publication-derivative")].related[?(@._direction=="to")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } },
    from: { '$.relationship[?(@._type=="publication-publication-derivative")].related[?(@._direction=="from")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } }
  },
  'rs_supplement' => { 
    to: { '$.relationship[?(@._type=="publication-publication-supplement")].related[?(@._direction=="to")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } },
    from: { '$.relationship[?(@._type=="publication-publication-supplement")].related[?(@._direction=="from")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } }
  },
  'rs_supersedes' =>  { 
    to: { '$.relationship[?(@._type=="publication-publication-supersedence")].related[?(@._direction=="to")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } },
    from: { '$.relationship[?(@._type=="publication-publication-supersedence")].related[?(@._direction=="from")]' => lambda { |d,o|
      rdata = { :id =>  d["_id"] }
      rdata
    } }
  },

  'rs_identifiers' => {
    identifiers: { '@' => lambda { |d,o|
      identifiers = []
      identifiers.concat d[:isbn_10].map { |i| "$$CISBN:$$V" + i } unless d[:isbn_10].nil?
      identifiers.concat d[:isbn_13].map { |i| "$$CISBN:$$V" + i } unless d[:isbn_13].nil?
      identifiers.concat d[:issn].map { |i| "$$CISSN:$$V" + i } unless d[:issn].nil?
      identifiers.concat d[:eissn].map { |i| "$$CEISSN:$$V" + i } unless d[:eissn].nil?
      identifiers.concat d[:doi].map { |i| "$$CDOI:$$V" + i } unless d[:doi].nil?
      # identifiers.concat d[:pmid].map { |i| "$$CPMID:$$V" + i } unless d[:pmid].nil?
      # identifiers.concat d[:scopusid].map { |i| "$$CSCOPUSID:$$V" + i } unless d[:doi].nil?
      # WOS-ID https://libis.teamwork.com/app/tasks/20947956 ( Web of Science  terms of use)
      # identifiers.concat d[:wosid].map { |i| "$$CWOSID:$$V" + i } unless d[:wosid].nil?
      identifiers.concat d[:external_identifiers].map { |i| "$$Cexternal_identifiers:$$V" + i } unless d[:external_identifiers].nil?
      identifiers.concat d[:patent_number].map { |i| "$$Cpatent_number:$$V" + i } unless d[:patent_number].nil?
      identifiers
    } }
  },

  'rs_search_creationdate' => {
    search_creationdate: { '@' => lambda { |d,o|

      search_creationdate = d[:acceptance_date].map { |d| d.gsub(/[-\/\.]/, '') }   unless d[:acceptance_date].nil?
      search_creationdate = d[:online_publication_date].map { |d| d.gsub(/[-\/\.]/, '') }  unless d[:online_publication_date].nil?
      search_creationdate = d[:publication_date].map { |d| d.gsub(/[-\/\.]/, '') } unless d[:publication_date].nil?
      search_creationdate

    } }
  },

  'rs_creationdate' => {
    risdate: { '@' => lambda { |d,o| d[:search_creationdate] }},
    creationdate: { '@' => lambda { |d,o|
      # rules_ng.run(RULE_SET_v2_1['rs_creationdate'], out.data, out, o)
      # PNX - creationdate, search_creationdate, search_startdate, search_enddate
      # For display the date format is yyyy-mm, exception dissertation:foramt is yyyy-mm-dd
      # Do not set a creation date if the field journal or parent_title exists in the record

      if d[:journal].nil? && d[:parent_title].nil? && !d[:search_creationdate].nil?
        creationdate = d[:search_creationdate].map { |d| d.gsub(/([\d]{4})([\d]{2})([\d]{2})/, '\1-\2') }
        if o[:type] === 'dissertation'
          creationdate = d[:search_creationdate].map { |d| d.gsub(/([\d]{4})([\d]{2})([\d]{2})/, '\1-\2-\3') }
        end
      end
      creationdate
    } },
    search_startdate: { '@' => lambda { |d,o|
      [d[:search_creationdate]].flatten&.first&.gsub(/(\d{4})(\d{4})/, '\10101')
    } },
    search_enddate: { '@' => lambda { |d,o|
      [d[:search_creationdate]].flatten&.first&.gsub(/(\d{4})(\d{4})/, '\11231')
    } }
  },
  'rs_files' =>  { 
    files: { '$.files.file' => lambda { |d,o|
      out = DataCollector::Output.new
      rules_ng.run(RULE_SET_v2_1['rs_file'], d, out, o)
      rdata = out.data
      # remove files from array with files.fileIntranet=false and files.filePublic=false
      if ( out.data["fileIntranet"].include?("false") &&  out.data["filePublic"].include?("false") )
        rdata = nil
      end
      rdata           
    }}
  },
  'rs_file' =>  { 
    filename: '$.filename',
    file_url: '$.file_url',
    description: '$.description',
    extension: '$.extension',
    embargo_release_date: { '$.embargo_release_date' => lambda { |d,o|
      if d.is_a?(Date)
        d.strftime("%Y-%m-%d")
      else
        d
      end
    } },
    embargo_description: '$.embargo_description',
    is_open_access: '$.is_open_access',
    filePublic: '$.filePublic',
    fileIntranet: '$.fileIntranet',
  },
  'rs_ispartof' => {
    ispartof: { '@' => lambda { |d,o|
      if d[:parent_title].nil? && d[:journal].nil?
        return nil
      end

      unless d[:journal].nil?
        ispartof = d[:journal].clone()
      end
      unless d[:parent_title].nil?
        ispartof = d[:parent_title].clone()
      end

      pp 'search_creationdate' if DEBUG
      unless d[:search_creationdate].nil?
        date =  d[:search_creationdate].map{ |d| d.gsub(/(\d{4})[\d-]*/, '\1') }.uniq.join(', ')
        ispartof.map! { |p| p + "; " + date }
      end

      pp 'volume' if DEBUG
      unless d[:volume].nil?
        volume = d[:volume].uniq.join(', ')
        ispartof.map! { |p| p + "; Vol. " + volume }
      end

      pp 'issue' if DEBUG
      unless d[:issue].nil?
        issue = d[:issue].uniq.join(', ')
        ispartof.map! { |p| p + "; iss. " + issue }
      end
      
      pp 'pagination' if DEBUG      
      unless d[:pagination].nil?
        d[:pagination] = [d[:pagination]].flatten&.map { |p|
          unless p["begin_page"].nil? && p["end_page"].nil?
            p_begin = "..."
            p_end   = "..."
            p_begin =  p["begin_page"] unless  p["begin_page"].nil?
            p_end   =  p["end_page"] unless  p["end_page"].nil?
            p["pagination"] = "#{p_begin} - #{p_end}"
          end
          p
        }
        pagination =  d[:pagination].map { |p|  p["pagination"] } .uniq.join(', ')
        unless pagination.empty?
          ispartof.map! { |p| p + "; pp. " + pagination }         
        end
      end
      if d[:type] === 'chapter'
        chapter = d[:number].uniq.join(', ')
        ispartof.map! { |p| p + "; Chapter Nr. " + chapter }
      end
      
      ispartof

    }}
  },
  'rs_delivery' => {
    delivery_delcategory: { '@' => lambda { |d,o|
      delivery_delcategory = "Remote Search Resource"
      unless d[:other_identifier].nil? && d[:doi].nil?
        delivery_delcategory = "fulltext_linktorsrc" 
      end
      delivery_delcategory
    }},
    linktorsrc: { '@' => lambda { |d,o|
      linktorsrc = nil
    
      unless d[:files].nil?

        pp 'rs_linktorsrc_from_files' if DEBUG

        o[:number_files] = 1
        o[:number_files] =  d[:files].size if d[:files].is_a?(Array)

        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_linktorsrc_from_files'], d[:files], out, o)
        linktorsrc = out.data[:linktorsrc_from_files]

        o[:number_files] = nil
      end

      unless d[:oa].nil? || d[:oa].include?("free_for_read") || d[:type] == "research_dataset"
        if linktorsrc.nil? && ( !d[:isbn_10].nil? || !d[:isbn_13].nil? || !d[:issn].nil? || !d[:eissn].nil?) 
          linktorsrc = ""
        end
      end      
      
      if linktorsrc.nil? && !d[:doi].nil?
        pp 'rs_linktorsrc_from_doi' if DEBUG
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_linktorsrc_from_doi'], d[:doi], out, o)
        linktorsrc = out.data[:linktorsrc_from_doi]
      end
      if linktorsrc.nil? && !d[:publisher_url].nil? && d[:type] != "research_dataset"
        pp 'rs_linktorsrc_from_publisher_url' if DEBUG
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_linktorsrc_from_publisher_url'], d[:publisher_url], out, o)
        linktorsrc = out.data[:linktorsrc_from_publisher_url]
      end
      if linktorsrc.nil? && !d[:additional_identifier].nil? && d[:type] != "research_dataset"
        pp 'rs_linktorsrc_from_additional_identifier' if DEBUG
        out = DataCollector::Output.new
        rules_ng.run(RULE_SET_v2_1['rs_linktorsrc_from_additional_identifier'], d[:additional_identifier], out, o)
        linktorsrc = out.data[:linktorsrc_from_additional_identifier]
      end

      linktorsrc
    }},
    delivery_fulltext: { '@' => lambda { |d,o|
      delivery_fulltext=nil
      unless d[:files].nil?
        delivery_fulltext = "fulltext_linktorsrc" 
      end
      unless d[:oa]&.include?("free_for_read")
        if delivery_fulltext.nil? && ( !d[:isbn_10].nil? || !d[:isbn_13].nil? || !d[:issn].nil?)
          delivery_fulltext = "fulltext_unknown" 
        end
      end
      if delivery_fulltext.nil? && !d[:doi].nil?
        delivery_fulltext = "fulltext_linktorsrc" 
      end
      if delivery_fulltext.nil? && !d[:publisher_url].nil? 
        delivery_fulltext = "fulltext_linktorsrc" 
      end
      if delivery_fulltext.nil? && !d[:additional_identifier].nil?
        delivery_fulltext = "fulltext_linktorsrc" 
      end
      if delivery_fulltext.nil?
        delivery_fulltext = "no_fulltext"
      end
      delivery_fulltext
    }}
  },
  'rs_linktorsrc_from_files'  =>{ 
    linktorsrc_from_files: { '@' => lambda { |file,o|

      if file.has_key?(:description) && file[:description].present? && !['Accepted version', 'Published version', 'Submitted version', 'Supporting version'].include?(file[:description].first)
        desc = file[:description].first
      else
        # if output.raw()[:files].size == 1 desc = "Link to resource"
        if o[:number_files] == 1 || file[:filename].nil?
          desc =  "Link to resource" 
        else
          desc = file[:filename].first 
        end
      end

      out = DataCollector::Output.new
      pp 'rs_file_restriction_desc' if DEBUG
      rules_ng.run(RULE_SET_v2_1['rs_file_restriction_desc'], file, out, o)
      restriction = out.data[:file_restriction_desc]&.first

      "$$U#{file[:file_url].first}$$D#{desc}#{restriction}$$Hfree_for_read"
    }}
  },
  'rs_linktorsrc_from_doi' => { 
    linktorsrc_from_doi: { '@' => lambda { |doi,o|
        "$$Uhttp://doi.org/#{doi}$$D#{doi}$$Hfree_for_read"
    }}
  },
  'rs_linktorsrc_from_publisher_url' => { 
    linktorsrc_from_publisher_url: { '@' => lambda { |d,o|
      "$$U#{d}$$Hfree_for_read" 
    }}
  },
  'rs_linktorsrc_from_additional_identifier' => { 
    linktorsrc_from_additional_identifier: { '@' => lambda { |d,o|
      if d.match(/^http/)
        "$$U#{d}$$Hfree_for_read"
      end
    }}
  },
  'rs_file_restriction_desc' => { 
    file_restriction_desc: { '@' => lambda { |file,o|

      pp 'rs_file_restriction_desc description' if DEBUG

      if file.has_key?(:description) && file[:description].present? && !['Accepted version', 'Published version', 'Submitted version', 'Supporting version'].include?(file[:description].first)
        desc = file[:description]&.first
      else
        desc = file[:filename]&.first # if output.raw()[:files].size == 1 desc = "Link to resource"
      end
     
      restriction = nil
      unless desc == "Supporting information"
        if file[:filePublic]&.first.to_s.downcase == "true"
          restriction ="freely available"
        else
          if file[:fileIntranet]&.first.to_s.downcase == "true"
            restriction = "Available for KU Leuven users"
            if file[:embargo_release_date]&.first
              unless file[:embargo_release_date].first.to_s.match(/^9999/)
                restriction = "Available for KU Leuven users - Embargoed until #{file[:embargo_release_date].first}"
              end
            end
          end
        end
        restriction = " [#{restriction}]" unless restriction == nil
      end

      restriction
    }}
  },
  'rs_open_access' => { 
    oa: { '@' => lambda { |d,o|
      open_access = nil    
=begin
  # Wordt "open-access-status" enkele toegevoegd als is-open-access de waarde "true" bevat ?
  # mogelijke waardes van open_access_status
  # Gold OA => maybe free_for_read 
  # Green OA => not free
  # Bronze OA => not free
  # Hybrid OA  => maybe free_for_read
  # Closed Access => not free
  # Open Access  => maybe free_for_read
=end
      if d[:open_access_status].is_a?(Array)
        open_access_status = d[:open_access_status].select{|ar| ["Open Access","Gold OA","Hybrid OA"].include?(ar) }
      end

      if d[:type] == "research_dataset" && !d[:accessright].nil? && !d[:accessright].any? {|ar| ["Restricted","Embargoed","Closed"].include?(ar) }
        open_access =  "free_for_read"
      end
      if  d[:type] != "research_dataset"
        unless [d[:files]].flatten.compact.select { |file| file[:description]&.first != "Supporting information" && file["filePublic"]&.first.to_s.downcase == "true" }.blank?
          open_access =  "free_for_read"
        else

  # "Mag de open-access indicator van Limo op true worden gezet ongeacht de andere velden als is-open-access de waarde "true" bevat ?"
  # => nee want het kan zijn dat iemand dit heeft aangevinkt terwijl er nog niets is opgeladen / geen url ingegeven.
  #  Minstens moet er dus gecheckt worden op aanwezigheid van bestand (als het kan dan liefst ook of het public is als dat niet te omslachtig is) of url in metadata.      
          if (d[:is_open_access].is_a?(Array) && d[:is_open_access].first.to_s.downcase == "true" ) || ! open_access_status.blank?
            if d[:files].nil?
              unless d[:publisher_url].nil?
                open_access =  "free_for_read"
              end
              unless d[:doi].nil?
                open_access =  "free_for_read"
              end
              pp 'rs_linktorsrc_from_additional_identifier' if DEBUG
              out = DataCollector::Output.new
              rules_ng.run(RULE_SET_v2_1['rs_linktorsrc_from_additional_identifier'], d[:additional_identifier], out, o)
              unless  out.data[:linktorsrc_from_additional_identifier].nil?
                open_access =  "free_for_read"
              end
            end          
          end

          if d[:is_open_access].is_a?(Array)
            if d[:is_open_access].first == "false"
              open_access = nil
            end
          end
        end
      end

      open_access
    }}
  },
  'rs_facets_toplevel' => { 
    facets_toplevel: { '@' => lambda { |d,o|
      facets_toplevel = []
      facets_toplevel << "open_access" unless d[:oa].nil? || d[:oa].empty?
      facets_toplevel << "online_resources" if d[:delivery_fulltext].include?("fulltext_linktorsrc")
      facets_toplevel << "peer_reviewed" if d[:peer_reviewed]&.any? { |s| s.match(/^Yes/i) }
      facets_toplevel
    }}
  },


}

