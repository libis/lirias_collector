require "test_helper"

DEBUG_TEST = true



# $ grep "lirias_ids =" parsing_test.rb  | cut -d "=" -f 2 | sed 's/\[//' |  sed 's/\]/,/'
=begin
lirias_ids = [ 1769877, 1128655, 1100345]
pp lirias_ids.sort.uniq

=end

aa = [

[:place_of_publication, 136525],

[:other_identifier_type, 3727576],
[:external_identifiers, 977104],
[:vabb_type, 977104],
[:vabb_identifier, 977104],
[:ispartof, 977104],
[:facets_toplevel, 977104],
[:publication_date, 1376504],
[:acceptance_date, 1376504],
[:pii, 1376504],
[:organizational_unit, 1376504],
[:embargo_release_date, 3958772],

[:isPartOf, 1376619],
[:book_title, 1389263],
[:article_title, 133926],
[:identifiers, 133926],
[:relation, 1902419],
[:serie, 1902419],
[:vertitle, 1820660],
[:notes,  1390611],
[:local_field_11, 1390611],
[:event,  136525],
[:local_field_02, 136525],

[:invitedby, 3152415],
[:organizational_unit, 1363603],
]


=begin
aa.each do |test|


puts "def test_#{test[0]}"
puts "      "
puts "  lirias_ids = [#{test[1]}]"
puts "  field = :#{test[0]}"
puts ""
puts "lirias_ids.each do |lirias_id|"
puts "  pp \"---- Test \#{lirias_id} \""
puts "  data = get_data(lirias_id)"
puts "  es_data = get_esdata(lirias_id)"
puts "  # show_for_debug(data,es_data,field)"
puts "  assert_equal(es_data[field], data[field])"
puts "end"
puts ""
end

=end

# number_of_pages in 1376619
# format/mediumm in 1376619

# 3702982 ===> supplemnt from ??
# 1376504
#  <api:field display-name="Open access" name="is-open-access" type="boolean">
#  <api:boolean>false</api:boolean>
#  </api:field>

# 791564 !!!! probleem id ??

 #gsub('&lt;\/', '&lt; /') outherwise wrong XML-parsing (see records lirias1729192 )

# claimed in 


# relationships in lirias 3037484 
# wosid in lirias 3037484 
# doi in 2365584
# keywords in lirias 3037484 
# dspace-keywords in lirias 3037484 
# virtual-collection in lirias 1769877
# abstract in 1769877
# pagination in 1769877
# volume in 2365584
# issue in 2365584

# parent_title in 1769877
# peer_reviewed in 1769877
# historic_collection in 1769877
# public_url in 1769877
# funding-acknowledgements in 2365584
# journal in 2365584 

# publication_status=>"Published online" in 2365584
# publication_status=>"Published" in 1769877
# professional_oriented in 2365584
# :language=>"English" in  2365584
# :language=>"en" in 1769877
# note in 3727576
# format in 3727576
# medium in 3727576
# accessright=>"open" in 3727576 (c-accessrights)
# accessright=>"Embargoed" in 3958772 (c-accessrights)
# edition in 1820660

# place_of_publication in 136525

# other_identifier_type in 3727576
# external_identifiers in 977104
# vabb_type in 977104
# vabb_identifier in 977104
# ispartof in 977104
# facets_toplevel [ peer_reviewed and online_resources] in 977104
# publication_date in 1376504
# online_publication_date in 
# acceptance_date in 1376504
# pii in 1376504
# organizational_unit in 1376504
# embargo_release_date in 3958772
 
# -- type: "dataset" = 3958772 met doi
# -- type: "dataset" = 3119197 geen doi wel files

# supervisor and co_supervisor and author in 1822382 (GEEN contributors)
# contributors (Architect, Curator, Editor) roles/functions 1685129
# contributors roles/functions 1685400
# contributors without roles/functions and not available in editor,translator,supervisor, ... 1928278
# editor 1403090
# c-editor 1685129
# editor 71653 ==> ???? author met achternaam Yeh (Editor) ????
# authors with role editor which are duplicated in c-editor 1694043
# translator 2788749
# contributors without roles/functions and duplicated in editor and translator 1815226
# book_series_editor in 1815248
# strange author role 3791606

# number_of_pages in 1376619
# format/mediumm in 1376619

# isPartOf in 1376619
# book_title in 1389263
# article_title in 133926
# identifiers in 133926
# relation / serie in 1902419
# vertitle in 1820660
# funding_acknowledgements, notes, local_field_11 in 1390611
# event, local_field_02 in 136525
# virtual collection 1100345
# invitedby in 3152415
# organizational_unit in 1363603

# files ??? 1087091
# dio no files ??? 136525
# isbn no doi and no files 1373285
# ==> lirias1815226 in full display in primo is "lirias type" = Translation 

#  ===> collections ??? availability ??? BOF ??? (lirias977104)



# 3702982 ===> supplemnt from ??
# 1376504
#  <api:field display-name="Open access" name="is-open-access" type="boolean">
#  <api:boolean>false</api:boolean>
#  </api:field>

# 791564 !!!! probleem id ??

 #gsub('&lt;\/', '&lt; /') outherwise wrong XML-parsing (see records lirias1729192 )



class DataCollectorInputTest < Minitest::Test

    #author => 1128655

    def test_identifiers
      
      lirias_id = 791564
      field = :identifiers

      data = get_data(lirias_id)
      es_data = get_esdata(lirias_id)      
      show_for_debug(data,es_data,field) if DEBUG_TEST
      unless es_data[field].nil? && data[field].nil?
        assert_equal(es_data[field], data[field])
      end
    end

    def test_wosid
      # WOS mag niet meer worden getoonds
      lirias_id = 3037484
      field = :identifiers

      data = get_data(lirias_id)
      es_data = get_esdata(lirias_id)

      show_for_debug(data,es_data,field) if DEBUG_TEST 
      assert_equal(es_data[field], data[field])
    end

    def test_doi
      lirias_id = 2365584
      field = :doi

      data = get_data(lirias_id)
      es_data = get_esdata(lirias_id)

      show_for_debug(data,es_data,field) if DEBUG_TEST 
      assert_equal(es_data[field], data[field])
    end

    def test_relations
      lirias_id = 3037484
      field = :relationship
      data = get_data(lirias_id)
      es_data = get_esdata(lirias_id)      
      show_for_debug(data,es_data,field) if DEBUG_TEST
      unless es_data[field].nil? && data[field].nil?
        assert_equal(es_data[field], data[field])
      end
    end

    def test_keywords
      lirias_id = 3037484
      field = :keywords
      data = get_data(lirias_id)
      es_data = get_esdata(lirias_id)

      show_for_debug(data,es_data,field) if DEBUG_TEST
      unless es_data[field].nil? && data[field].nil?
        assert_equal(es_data[field], data[field])
      end

      field = :dspace_keywords
      unless es_data[field].nil? && data[field].nil?
        assert_equal(es_data[field], data[field])
      end
    end

    def test_virtual_collections
      lirias_ids = [1769877, 1128655, 1100345]
      field = :virtual_collections

      lirias_ids.each do |lirias_id|
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_abstract
      lirias_ids = [1769877]
      field = :abstract

      lirias_ids.each do |lirias_id|
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_pagination
      lirias_ids = [1769877]
      field = :pagination

      lirias_ids.each do |lirias_id|
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)      
        

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end


    def test_volume
      lirias_ids = [2365584]
      field = :volume

      lirias_ids.each do |lirias_id|
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

      show_for_debug(data,es_data,field) if DEBUG_TEST
      unless es_data[field].nil? && data[field].nil?
        assert_equal(es_data[field], data[field])
      end
      end
    end

    def test_issue
      lirias_ids = [2365584]
      field = :issue

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end    

    def test_parent_title
      lirias_ids = [1769877]
      field = :parent_title

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end    

    def test_peer_reviewed
      lirias_ids = [1769877]
      field = :peer_reviewed

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end      

    def test_historic_collection
      lirias_ids = [1769877]
      field = :historic_collection

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_funding_acknowledgements
      lirias_ids = [2365584, 1390611]
      field = :funding_acknowledgements

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end         

    def test_journal
      lirias_ids = [2365584]
      field = :journal

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end         

    def test_publication_status
      lirias_ids = [2365584,1769877]
      field = :publication_status

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_professional_oriented
      lirias_ids = [2365584]
      field = :professional_oriented

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_language
      lirias_ids = [2365584,1769877]
      field = :language

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end       

    def test_note
      lirias_ids = [3727576]
      field = :note

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end       

    def test_format
      lirias_ids = [3727576]
      field = :format

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end       

    def test_medium
      lirias_ids = [3727576]
      field = :medium

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)      

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end       

    def test_accessright
      lirias_ids = [3727576,3958772]
      field = :accessright

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end       

    def test_edition
      lirias_ids = [1820660]
      field = :edition

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)


        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end 


    def test_place_of_publication

      lirias_ids = [136525]
      field = :place_of_publication
      
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_other_identifier_type
    
      lirias_ids = [3727576]
      field = :other_identifier_type
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_external_identifiers
    
      lirias_ids = [977104]
      field = :external_identifiers
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_vabb_type
    
        lirias_ids = [977104]
        field = :vabb_type
      
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_vabb_identifier
    
      lirias_ids = [977104]
      field = :vabb_identifier
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_ispartof
    
      lirias_ids = [977104]
      field = :ispartof
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_oa
    
      lirias_ids = [4080935,977104,71653,893282,3655807,1373285, 1739312, 1769877, 4080935, 977104,  791564, 829591, 1376504,2291528]

      field = :oa
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    

    def test_facets_toplevel
    
      lirias_ids = [977104,71653]
      field = :facets_toplevel
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_publication_date
    
      lirias_ids = [1376504]
      field = :publication_date
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_acceptance_date
    
      lirias_ids = [1376504]
      field = :acceptance_date
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_pii
    
      lirias_ids = [1376504]
      field = :pii
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_organizational_unit
    
      lirias_ids = [1376504]
      field = :organizational_unit
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_embargo_release_date
    
      lirias_ids = [3958772]
      field = :embargo_release_date
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_isPartOf
    
      lirias_ids = [1376619]
      field = :isPartOf
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_book_title
    
      lirias_ids = [1389263]
      field = :book_title
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_article_title
    
      lirias_ids = [133926]
      field = :article_title
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_relation
    
      lirias_ids = [1902419]
      field = :relation
      
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end
    
    def test_serie
    
      lirias_ids = [1902419]
      field = :serie
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_vertitle
    
      lirias_ids = [1820660]
      field = :vertitle
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_notes
    
      lirias_ids = [1390611]
      field = :notes
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_local_field_11
    
      lirias_ids = [1390611]
      field = :local_field_11
      
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_event
    
      lirias_ids = [136525]
      field = :event
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_local_field_02
    
      lirias_ids = [136525]
      field = :local_field_02
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_invitedby
    
      lirias_ids = [3152415]
      field = :invitedby
      
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_organizational_unit
    
      lirias_ids = [1363603]
      field = :organizational_unit
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_author
    
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
      field = :author
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end


    def test_editor
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606, 4021242]
      lirias_ids = [1928278]
      
      field = :editor
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)


        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_contributors
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
      field = :contributors
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_translator
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
      field = :translator
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_supervisor
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
      field = :supervisor
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end

    def test_co_supervisor
      lirias_ids = [1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
      field = :co_supervisor
    
      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end




# 1769877 public_url
# 893282 linktorsrc / fulltext_unknown
# 4080935 Embargoed until 2024-05-30


    def test_public_url
      lirias_ids = [1769877,893282,4080935]
      field = :public_url

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        data_field = process_field( data[field] )
        es_data_field = process_field( es_data[field] )
        show_for_debug(data,es_data,field) if DEBUG_TEST
        assert_equal(es_data_field, data_field)
      end
    end         


    
    def test_all
      lirias_ids = [71653,
        133926,
        136525,
        791564,
        977104,
        1100345,
        1128655,
        1363603,
        1376504,
        1376619,
        1389263,
        1390611,
        1403090,
        1685129,
        1685400,
        1694043,
        1769877,
        1815226,
        1815248,
        1820660,
        1822382,
        1902419,
        1928278,
        2365584,
        2788749,
        3037484,
        3152415,
        3727576,
        3791606,
        3958772,1769877,893282,4080935,3958772,3119197]

      lirias_ids = lirias_ids.sort.uniq

      # pp lirias_ids


      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        
        unless es_data.nil? || data.nil?
          pp "====> es_data or data is nil in test_all"
          es_data_keys = es_data.keys.sort
          data_keys = data.keys.sort
          pp data_keys - es_data_keys
          pp es_data_keys - data_keys
          # pp data.keys.sort
          assert_equal(es_data.keys.sort, data.keys.sort)
        end

        unless es_data.nil? && data.nil?
          assert_equal(es_data, data)
        end
        pp "-----------------------"
      end
      
    end
    
end

