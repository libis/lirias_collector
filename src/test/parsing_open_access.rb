require "test_helper"

DEBUG_DEL_TEST=true

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
# 2936906 file available maar geen aanduiding filePublic of fileIntranet (but it is not claimed) => record not FOUND
# 791564 : Geen file, wel ISSN en doi
# 2291528 : 1 filePublic file  “Published version” , DOI en ISSN en eISSN
# 3684711: dataset” Geen files, wel doi
# 3655807 : 1 filePublic file supporting information, DOI en ISSN


@@lirias_test_ids = [662170, 1639312, 1664993, 3655807, 2291528, 1769877,
1595878, 
3476821,  
1739270, 
3684711, 
1795898, 
2946871, 
3418094, 
1573899,
1573924,
1573951, 
1534644,
1536823,
1536891, 
2374346, 
2808948,
2808948,
3043544,
1567197, 
1570828, 
1564795,
3418094, 
2946871, 
1691558, 
1577495, 
1600721, 
1602525, 
1572970, 
1573268, 
1575512,
1647743,
3043544
]

# muts be free to read
@@lirias_test_ids = [ 1573899, 1573924, 1573951, 2374346, 2808948, 2808948, 3043544, 1647743, 1424000, ]

@@lirias_test_ids = [ 1573899]

    def test_open_access
      lirias_ids = @@lirias_test_ids
      field = :oa

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_equal("free_for_read", data[field])
        #  assert_equal(es_data[field], data[field])
        end
      end
    end         
    
# must be no open_access
@@lirias_test_ids_nil = [ 1769877, 1739312, 1769877, 1534644, 1536823, 1536891, 1739270, 1739270, 1573268, 1575512, 1567197, 1570828, 1564795, 3418094, 2946871, 1691558, 1795898 ]

    def test_open_access_nil
      lirias_ids = @@lirias_test_ids_nil
      field = :oa

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} / #{field}"
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)
        show_for_debug(data,es_data,field) if DEBUG_DEL_TEST
        unless es_data[field].nil? && data[field].nil?
          assert_nil( data[field])
        end
      end
    end  


end

