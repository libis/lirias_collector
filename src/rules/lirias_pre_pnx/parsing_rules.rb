   
def parse_record(object)

  output[:id] = filter(object, '@._id')
  output[:claimed] = filter(object, '$.claimed')
    
  if output[:claimed].present? && output[:claimed][0].to_s == "false"
    output[:deleted] = filter(object, '@._last_affected_when')
    deleted_when = output[:deleted][0]
  else

    output[:type] = filter(object, '@._type')
    output[:updated] = filter(object, '@._last_affected_when')
    output[:elements_creation_date] = filter(object, '@._created_when')

    #log(" record id #{ output[:id] } ")

    #Filter on every keyword
    dspace_keywords = []
    virtual_collections = []
    keywords = []
    filter(object, '$..keywords.keyword').each do |keyword|
      #log(" Keyword ---- #{ keyword } ")
      if keyword.is_a?(Nori::StringWithAttributes)
        # log(" Keyword ---- #{ keyword.attributes } ")
        # if filter( keyword.attributes.to_json, '$[?(@.scheme=="c-virtual-collection"]').any?
        if (keyword.attributes)["scheme"] == "c-virtual-collection" 
            virtual_collections << keyword
        else
          keywords << keyword
          dspace_keywords << keyword  if filter( keyword.attributes.to_json, '$[?(@.source=="dspace")]').any?
        end
      else 
        keywords << keyword
      end
    end
    output[:virtual_collections] = virtual_collections 
    output[:dspace_keywords] = dspace_keywords 
    output[:keyword] = keywords

    filter(object, '$.records.record') .each do |record|
      output[:pmid]     = record["_id_at_source"] if  record["_source_name"] == "pubmed"
      output[:wosid]    = record["_id_at_source"] if  record["_source_name"] == "wos"
      output[:scopusid] = record["_id_at_source"] if  record["_source_name"] == "scopus"
    end

    output[:correction_to]   = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-correction")].related[?(@._direction=="to")]._id')
    output[:correction_from] = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-correction")].related[?(@._direction=="from")]._id')

    output[:derivative_to]   = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-derivative")].related[?(@._direction=="to")]._id')
    output[:derivative_from] = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-derivative")].related[?(@._direction=="from")]._id')

    output[:supplement_to]   = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-supplement")].related[?(@._direction=="to")]._id')
    output[:supplement_from] = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-supplement")].related[?(@._direction=="from")]._id')

    output[:supersedes_to]   = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-supersedence")].related[?(@._direction=="to")]._id')
    output[:supersedes_from] = filter(object, '$..relationships.relationship[?(@._type=="publication-publication-supersedence")].related[?(@._direction=="from")]._id')


    #Filter on every record with source_name merged !
    filter(object, '$.records.record[?(@._source_name=="merged")]').each do |record|
      
      output[:title] = filter(record, '$..native.field[?(@._name=="title")].text')

      output[:alternative_title] = filter(record, '$..native.field[?(@._name=="c-alttitle")].text')
      output[:abstract] = filter(record, '$..native.field[?(@._name=="abstract")].text')
      output[:author]     = filter(filter(record, '$..native.field[?(@._name=="authors")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:author_url] = filter(record, '$..native.field[?(@._name=="author-url")].text')
                     
      output[:serie] = filter(record, '$..native.field[?(@._name=="series")].text')
      output[:book_serie] = filter(record, '$..native.field[?(@._name=="c-series-editor")].text')
      output[:edition] = filter(record, '$..native.field[?(@._name=="edition")].text')
      output[:volume] = filter(record, '$..native.field[?(@._name=="volume")].text')
      output[:issue] = filter(record, '$..native.field[?(@._name=="issue")].text')

      output[:pagination]      = filter(record, '$..native.field[?(@._name=="pagination")][?(@._display_name=="Pagination")].pagination')
      output[:number_of_pages] = filter(record, '$..native.field[?(@._name=="pagination")][?(@._display_name=="Pagination")].pagination.page_count')
      
      output[:pagination]      = filter(record, '$..native.field[?(@._name=="pagination")][?(@._display_name=="Number of pages")].pagination')
      output[:number_of_pages] = filter(record, '$..native.field[?(@._name=="pagination")][?(@._display_name=="Number of pages")].pagination.page_count')

      output[:publisher] = filter(record, '$..native.field[?(@._name=="publisher")].text')
      output[:publisher_url] = filter(record, '$..native.field[?(@._name=="publisher-url")].text')
      output[:place_of_publication] = filter(record, '$..native.field[?(@._name=="place-of-publication")].text')
      output[:publication_date] = filter(record, '$..native.field[?(@._name=="publication-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:online_publication_date] = filter(record, '$..native.field[?(@._name=="online-publication-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:acceptance_date] = filter(record, '$..native.field[?(@._name=="acceptance-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:isbn_10] = filter(record, '$..native.field[?(@._name=="isbn-10")].text')
      output[:isbn_13] = filter(record, '$..native.field[?(@._name=="isbn-13")].text')
      output[:doi] = filter(record, '$..native.field[?(@._name=="doi")].text')
      output[:medium] = filter(record, '$..native.field[?(@._name=="medium")].text')
      output[:publication_status] = filter(record, '$..native.field[?(@._name=="publication-status")].text')
      output[:note] = filter(record, '$..native.field[?(@._name=="notes")].text')
      output[:numbers] = filter(record, '$..native.field[?(@._name=="numbers")].text')
      output[:chapter_number] = filter(record, '$..native.field[?(@._display_name=="Chapter number")].text')
      output[:abstract_number] = filter(record, '$..native.field[?(@._display_name=="Abstract number")].text')
      output[:report_number] = filter(record, '$..native.field[?(@._display_name=="Report number")].text')
      output[:paper_number] = filter(record, '$..native.field[?(@._display_name=="Paper number")].text')
      output[:article_number] = filter(record, '$..native.field[?(@._display_name=="Article number")].text')
    
      output[:parent_title] = filter(record, '$..native.field[?(@._name=="parent-title")].text')
      output[:name_of_conference] = filter(record, '$..native.field[?(@._name=="name-of-conference")].text')
      output[:location] = filter(record, '$..native.field[?(@._name=="location")].text')
      output[:start_date] = filter(record, '$..native.field[?(@._name=="start-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1'}-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:finish_date] = filter(record, '$..native.field[?(@._name=="finish-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:journal] = filter(record, '$..native.field[?(@._name=="journal")].text')
      output[:issn] = filter(record, '$..native.field[?(@._name=="issn")].text')
      output[:pii] = filter(record, '$..native.field[?(@._name=="pii")].text')
      output[:language] = filter(record, '$..native.field[?(@._name=="language")].text')
      output[:patent_number] = filter(record, '$..native.field[?(@._name=="patent-number")].text')
      output[:associated_authors] = filter(filter(record, '$..native.field[?(@._name=="associated-authors")].people.person'), [:first_names, :last_name, :initials, :roles])
      output[:filed_date] = filter(record, '$..native.field[?(@._name=="filed-date")].date').map {
        |d| DateTime.parse("#{d['year']}-#{d['month'] || '1' }-#{d['day'] || '1'}  ").strftime("%Y-%m-%d")
      } 
      output[:patent_status] = filter(record, '$..native.field[?(@._name=="patent-status")].text')
      output[:commissioning_body] = filter(record, '$..native.field[?(@._name=="commissioning-body")].text')
      output[:confidential] = filter(record, '$..native.field[?(@._name=="confidential")].boolean').map(&:to_s)
      output[:number_of_pieces] = filter(record, '$..native.field[?(@._name=="number-of-pieces")].boolean').map(&:to_s)
      output[:version] = filter(record, '$..native.field[?(@._name=="version")].boolean').map(&:to_s)
      output[:eissn] = filter(record, '$..native.field[?(@._name=="eissn")].text')
      output[:external_identifiers] = filter(record, '$..native.field[?(@._name=="external-identifiers")].identifiers.identifier')

      output[:other_identifier] = filter(record, '$..native.field[?(@._name=="c-identifier-other"].text')
      output[:other_identifier_type] = filter(record, '$..native.field[?(@._name=="c-identifierother-type")].text')

      output[:other_identifiers_handle] = filter(record, '$..native.field[?(@._name=="c-identifier-other" && @._type="handle")].text')
      output[:other_identifiers_url] = filter(record, '$..native.field[?(@._name=="c-identifier-other" && @._type="url")].text')
      output[:other_identifiers_urn] = filter(record, '$..native.field[?(@._name=="c-identifier-other" && @._type="urn")].text')
      output[:other_identifiers_purl] = filter(record, '$..native.field[?(@._name=="c-identifier-other" && @._type=purl")].text')
      output[:other_identifiers_ark] = filter(record, '$..native.field[?(@._name=="c-identifier-other" && @._type="ark")].text')

      output[:peer_reviewed] = filter(record, '$..native.field[?(@._name=="c-peer-review")].text')
      output[:invitedby] = filter(record, '$..native.field[?(@._name=="c-invitedby")].text')
      output[:professional_oriented] = filter(record, '$..native.field[?(@._name=="c-professional")].boolean').map(&:to_s)
      output[:funding_acknowledgements] = filter(record, '$..native.field[?(@._name=="funding-acknowledgements")].funding_acknowledgements.acknowledgement_text')
      output[:vabb_type] = filter(record, '$..native.field[?(@._name=="c-vabb-type")].text')
      output[:vabb_identifier] = filter(record, '$..native.field[?(@._name=="c-vabb-identifier")].text')
      output[:historic_collection] = filter(record, '$..native.field[?(@._name=="c-collections-historic")].items.item')

      output[:public_url] = filter(record, '$..native.field[?(@._name=="public-url")].text')
#       output[:files] = filter( filter(record, '$..native.files.file') ,  [:file_url, :filename, :description, :extension, :embargo_release_date, :embargo_description, :is_open_access, :filePublic, :fileIntranet])
   
#### HACK If there is & XML-problem ? (<files><file> ... </file></files> <files><file> ... </file></files>)
#### https://libis.teamwork.com/desk/#/tickets/86293747

      files = []
      filter(record, '$..native.files').each do |ffile|
          (files << filter(  filter( ffile, '$.file'), [:file_url, :filename, :description, :extension, :embargo_release_date, :embargo_description, :is_open_access, :filePublic, :fileIntranet] )).flatten!
      end

      output[:files] = files

      # Open => Online Access, Restricted=> Check availability, Embargoed=> Check avalailability, Closed=> No online access
      output[:accessright] = filter(record, '$..native.field[?(@._name=="c-accessrights")].text')

      output[:embargo_release_date] =  filter(filter(record, '$..native.field[?(@._name=="c-date-end-of-embargo")].date'), [:day, :month, :year])

      output[:venue_designart] = filter(record, '$..native.field[?(@._name=="c-venue-designart")].items.item')
      output[:additional_identifier] = filter(record, '$..native.field[?(@._name=="c-additional-identifier")].items.item')

      output[:organizational_unit] = filter(record, '$..native.field[?(@._name=="cache-user-ous")].items.item')

      output[:editor]             = filter(filter(record, '$..native.field[?(@._name=="editors")][?(@._display_name=="Editors")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])

      output[:supervisor]         = filter(filter(record, '$..native.field[?(@._name=="editors")][?(@._display_name=="Supervisor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:co_supervisor]      = filter(filter(record, '$..native.field[?(@._name=="c-cosupervisor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])

      output[:translator]         = filter(filter(record, '$..native.field[?(@._name=="c-translator")][?(@._display_name=="Translator")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])

      output[:book_series_editor] = filter(filter(record, '$..native.field[?(@._name=="c-series-editor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])

      output[:contributor]        = filter(filter(record, '$..native.field[?(@._name=="c-contributor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])

=begin     
# deprecated (Use creditRoles)
      output[:actor]              = filter(filter(record, '$..native.field[?(@._name=="c-actor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:architect]          = filter(filter(record, '$..native.field[?(@._name=="c-architect")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:choreographer]      = filter(filter(record, '$..native.field[?(@._name=="c-choreographer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:cinematographer]    = filter(filter(record, '$..native.field[?(@._name=="c-cinematographer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:composer]           = filter(filter(record, '$..native.field[?(@._name=="c-composer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:conductor]          = filter(filter(record, '$..native.field[?(@._name=="c-conductor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:curator]            = filter(filter(record, '$..native.field[?(@._name=="c-curator")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:director]           = filter(filter(record, '$..native.field[?(@._name=="c-director")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:editor_c]           = filter(filter(record, '$..native.field[?(@._name=="c-editor")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      
      output[:educator]           = filter(filter(record, '$..native.field[?(@._name=="c-educator")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:interaction]        = filter(filter(record, '$..native.field[?(@._name=="c-interaction-designer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:interior_architect] = filter(filter(record, '$..native.field[?(@._name=="c-interior-architect")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:game_designer]      = filter(filter(record, '$..native.field[?(@._name=="c-game-designer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:graphic_designer]   = filter(filter(record, '$..native.field[?(@._name=="c-graphic-designer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:landscape_architect]= filter(filter(record, '$..native.field[?(@._name=="c-landscape-architect")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:music_performer]    = filter(filter(record, '$..native.field[?(@._name=="c-music-performer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:otherrole]          = filter(filter(record, '$..native.field[?(@._name=="c-otherrole")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:photographer]       = filter(filter(record, '$..native.field[?(@._name=="c-photographer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:producer]           = filter(filter(record, '$..native.field[?(@._name=="c-producer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:product_designer]   = filter(filter(record, '$..native.field[?(@._name=="c-product-designer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:sound_artist]       = filter(filter(record, '$..native.field[?(@._name=="c-sound-artist")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      
      output[:urban_designer]     = filter(filter(record, '$..native.field[?(@._name=="c-urban-designer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:visual_artist]      = filter(filter(record, '$..native.field[?(@._name=="c-visual-artist")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
      output[:writer]             = filter(filter(record, '$..native.field[?(@._name=="c-writer")].people.person'), [:first_names, :last_name, :initials, :username, :identifiers, :roles])
=end

=begin     
# deprecated (Use creditRoles)
      author_functions = [
        :actor, 
        :architect,
        :book_series_editor,
        :choreographer,
        :cinematographer,
        :composer,
        :conductor,
        :curator,
        :director,
        :editor_c,
        :educator,
        :interaction,
        :interior_architect,
        :game_designer,
        :graphic_designer,
        :landscape_architect,
        :music_performer,
        # :otherrole,
        :photographer,
        :producer,
        :product_designer,
        :sound_artist,
        :urban_designer,
        :visual_artist,
        :writer,
      ]
=end

      author_function_mapping = {
        :book_series_editor => "Book Series Editor",
        :editor_c    => "Editor",
        :interaction => "Interactor",
        :otherrole => "Other role"
      }


      #output[:contributor_test] = output[:contributor].clone
      #output[:contributor_test] = Marshal.load(Marshal.dump(output[:contributor]))
      [:editor, :supervisor, :co_supervisor, :translator ].each do |author_type|
        if output[author_type]
          output.raw()[author_type].each do |function_person|
            added_to_contributor = false
            if ! output[:contributor]
              output[:contributor] = Marshal.load(Marshal.dump(output.raw()[author_type]))
            end
            # check if the name, identifiers, ... of author_function and author_type are the same.
            # add function ("editor", "supervisor", "co_supervisor", "translator") to author_type
            # Or copy author_type to contributor
            output[:contributor].each do |contri_person|
              if  contri_person["last_name"] == function_person["last_name"] &&  
                contri_person["first_name"] == function_person["first_name"] &&  
                contri_person["initials"] == function_person["initials"] && 
                contri_person["identifiers"] == function_person["identifiers"]  
                contri_person["function"] ? contri_person["function"] << author_type.to_s.capitalize.gsub(/_/,' ') : contri_person["function"] = [author_type.to_s.capitalize.gsub(/_/,' ')]
                contri_person["function"].uniq
                contri_person["roles"] ? contri_person["roles"]["role"] << author_type.to_s.capitalize.gsub(/_/,' ') : contri_person["roles"] = { "role" => [author_type.to_s.capitalize.gsub(/_/,' ')] }
                contri_person["roles"].uniq
                added_to_contributor = true
              end
            end
            if ! added_to_contributor
              contri_person = Marshal.load(Marshal.dump(function_person))
              contri_person["function"] ? contri_person["function"] << author_type.to_s.capitalize.gsub(/_/,' ') : contri_person["function"] = [author_type.to_s.capitalize.gsub(/_/,' ')]
              contri_person["function"].uniq
              contri_person["roles"] ? contri_person["roles"]["role"] << author_type.to_s.capitalize.gsub(/_/,' ') : contri_person["roles"] = { "role" => [author_type.to_s.capitalize.gsub(/_/,' ')] }
              contri_person["roles"].uniq
              output[:contributor]  << contri_person
            end
          end
        end
      end
=begin
# deprecated (Use creditRoles)
      # loop over author functions
      # if output contains this author_function
      # loop over author types
      # if output contains this author_type 
      # check if the name, identifiers, ... of author_function and author_type are the same.
      # add function to author_type
      author_functions.each do |function|
        if output[function]
          output.raw()[function].each do |pfunction|
            [:author, :editor, :supervisor, :co_supervisor, :contributor, :translator].each do |author_type|
              if output[author_type]
                 # log(" record function  #{ function.to_s } ")
                output[author_type].map do |person|
                  if  person["last_name"] == pfunction["last_name"] &&  
                    person["first_name"] == pfunction["first_name"] &&  
                    person["initials"] == pfunction["initials"] && 
                    person["identifiers"] == pfunction["identifiers"]  
                    displ_function = author_function_mapping[ function ] || function.to_s.capitalize.gsub(/_/,' ');
                    person["function"] ? person["function"] << displ_function : person["function"] = [displ_function]
                    person["function"].uniq
                  else
                    person
                  end
                end
              end
            end
          end
        end
      end
=end

    end
  end
end
