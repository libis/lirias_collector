require "test_helper"

DEBUG_DEL_TEST=false

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

# relationships in lirias 3037484 


class DataCollectorInputTest < Minitest::Test

   #author => 1128655

# 1769877 intranet file met embargo untill 9999-12-31 geen file description
# 893282 geen files wel isbn, Additional identifiers en publisher-url
# 4080935 intranet file met Embargoed until 2024-05-30 en filedescription "Published version"

# 3958772 "dataset" met doi
# 3119197 "dataset" geen doi wel files

# 1087091 public file 
# 136525 geen files wel issn, isbn en doi
# 1373285  geen files wel issn

# 2842609 internet publication

# 1950560 intranet file geen Embargoed 
# 2936906 file available maar geen aanduiding filePublic of fileIntranet (but it is not claimed)
# 791564 : Geen file, wel ISSN en doi
# 2291528 : 1 filePublic file  “Published version” , DOI en ISSN en eISSN
# 3684711: dataset” Geen files, wel doi
# 3655807 : 1 filePublic file supporting information, DOI en ISSN


@@lirias_test_ids = [1087091, 136525, 1373285, 1769877,893282,4080935, 1815226, 977104, 2936906, 2858842, 791564, 2291528, 3684711, 3655807, 2842609 ]

    def test_public_url
      lirias_ids = @@lirias_test_ids
      field = :public_url

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_equal(es_data[field], data[field])
        end
      end
    end         

    def test_fulltext
      lirias_ids = @@lirias_test_ids
      field = :delivery_fulltext

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_equal(es_data[field], data[field])
        end
      end
    end         

    def test_fulltext_dataset
        lirias_ids = @@lirias_dataset_test_ids
        field = :delivery_fulltext
  
        lirias_ids.each do |lirias_id|
          pp "---- Test #{lirias_id} / #{field}"
          data = get_data(lirias_id)
          es_data = get_esdata(lirias_id)
          show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
          unless es_data[field].nil? && data[field].nil?
            assert_equal(es_data[field], data[field])
          end
        end
    end   

    def test_linktorsrc
      lirias_ids = @@lirias_test_ids
      field = :linktorsrc

      lirias_ids.each do |lirias_id|
         pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_equal(es_data[field], data[field])
        end
      end
    end      

    def test_linktorsrc_dataset
        lirias_ids = @@lirias_dataset_test_ids
        field = :linktorsrc
  
        lirias_ids.each do |lirias_id|
           pp "---- Test #{lirias_id} / #{field}"
          data = get_data(lirias_id)
          es_data = get_esdata(lirias_id)
          show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
          unless es_data[field].nil? && data[field].nil?
            assert_equal(es_data[field], data[field])
          end
        end
    end      
  
    def test_delcategory
        lirias_ids = @@lirias_test_ids
        field = :delivery_delcategory
  
        lirias_ids.each do |lirias_id|
          pp "---- Test #{lirias_id} / #{field}"
          data = get_data(lirias_id)
          es_data = get_esdata(lirias_id)
          show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
          unless es_data[field].nil? && data[field].nil?
            assert_equal(es_data[field], data[field])
          end
        end
    end   

    def test_delcategory_dataset
      lirias_ids = @@lirias_dataset_test_ids
      field = :delivery_delcategory

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_equal(es_data[field], data[field])
        end
      end
    end    

     
end

