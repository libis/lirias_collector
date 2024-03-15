require "test_helper"

DEBUG_TEST = true

class DataCollectorInputTest < Minitest::Test

# $ grep "lirias_ids =" parsing_test.rb  | cut -d "=" -f 2 | sed 's/\[//' |  sed 's/\]/,/'
=begin
lirias_ids = [ 1769877, 1128655, 1100345]
pp lirias_ids.sort.uniq

=end


# Journal article:	lirias100041
# Book:	lirias1106653
# Book chapter:	lirias1061017
# Conference proceeding:	lirias1001362
# Abstract/Presentation/Poster:	lirias1112360
# Creation in the arts or design:	lirias3440711
# Phd Thesis:	lirias1061008
# Book review:	lirias3440711
# Report	 lirias1106285
# Science outreach:	lirias1660996
# Other:	lirias3551395
# Research Dataset:	lirias2894659
# Software:	lirias2934008
# Internet publication:	lirias3382196
# Translation:	lirias3448948
# Edited book:	lirias1658685
# Invited lecture:	lirias1711997
# Preprint:	lirias3759221
# Book review:	lirias2759464
# Dataset:	lirias2894659

#fields = [ :abstract ]
# , :abstract_number, :acceptance_date, :accessright, :additional_identifier, :alternative_title, :article_number, :article_title, :author, :author_url, :backlink, :book_series_editor, :book_title, :chapter_number, :claimed, :co_supervisor, :commissioning_body, :confidential, :contributor, :creator, :delivery_delcategory, :delivery_fulltext, :description, :doi, :dspace_keywords, :duration, :edition, :editor, :eissn, :elements_creation_date, :embargo_release_date, :event, :external_identifiers, :facets_creator_contributor, :facets_prefilter,  :facets_rsrctype, :facets_staffnr, :facets_toplevel, :filed_date, :files, :finish_date, :first_author, :format ]

=begin
  :funding_acknowledgements,
  :historic_collection,
  :id,
  :identifiers,
  :invitedby,
  :is_open_access,
  :isbn_10,
  :isbn_13,
  :ispartof,
  :issn,
  :issue,
  :journal,
  :journal_title,
  :keyword,
  :language,
  :linktorsrc,
  :lirias_type,
  :local_facet_10,
  :local_field_02,
  :local_field_07,
  :local_field_08,
  :local_field_09,
  :local_field_10,
  :local_field_11,
  :location,
  :medium,
  :name_of_conference,
  :note,
  :notes,
  :number_of_pages,
  :oa,
  :online_publication_date,
  :open_access_status,
  :organizational_unit,
  :other_identifier_type,
  :pagination,
  :paper_number,
  :parent_title,
  :peer_reviewed,
  :pii,
  :place_of_publication,
  :pmid,
  :professional_oriented,
  :public_url,
  :publication_date,
  :publication_status,
  :publisher,
  :publisher_url,
  :recordid,
  :relation,
  :relationship,
  :report_number,
  :risdate,
  :ristype,
  :scopusid,
  :search_creationdate,
  :search_enddate,
  :search_startdate,
  :serie,
  :source,
  :sourceid,
  :sourcerecordid,
  :start_date,
  :subject,
  :supervisor,
  :title,
  :translator,
  :type,
  :updated,
  :vabb_identifier,
  :vabb_type,
  :venue_designart,
  :vertitle,
  :virtual_collections,
  :volume,
  :wosid
=end

@@excludefields = [ :es_created, :es_updated, :updated, :claimed, :oa, :delivery_fulltext, :facets_toplevel ]

@@lirias_test_ids = [71653,
  133926,
  136525,
  791564,
  893282,
  977104,
  1087091,
  1100345,
  1128655,
  1363603,
  1373285,
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
  3119197,
  3152415,
  3727576,
  3791606,
  3958772,
  4021242,
  2858842,
  4080935,
  100041,
  1106653,
  1061017,
  1001362,
  1112360,
  3440711,
  1061008,
  3440711,
  1106285,
  1660996,
  3551395,
  2894659,
  2934008,
  3382196,
  3448948,
  1658685,
  1711997,
  3759221,
  2759464,
  2894659,
  1332692,
  1128655, 1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606, 1815226,
  1769877, 1739312, 1769877, 1534644, 1536823, 1536891, 1739270, 1739270, 1573268, 1575512, 1567197, 1570828, 1564795, 3418094, 2946871, 1691558, 1795898,
  662170, 1639312, 1664993, 3655807, 2291528, 1769877,
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
  3043544,
  1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606,
  71653,
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
  3958772,1769877,893282,4080935,3958772,3119197
]
    
    def test_all
      lirias_ids = @@lirias_test_ids
      exclude_fields = @@excludefields 
      lirias_ids = lirias_ids.sort.uniq

      #lirias_ids = [1902419]
      pp lirias_ids

      pp "CHECK migration scripts in test helper !!! "

      test_results={}
      tested_fields=[]

      lirias_ids.each do |lirias_id|
        pp "---- Test #{lirias_id} "
        data = get_data(lirias_id)
        es_data = get_esdata(lirias_id)

        unless es_data.nil? || data.nil?
          es_data_keys = es_data.keys.sort
          data_keys = data.keys.sort

          # pp "#{ data_keys - es_data_keys }  -vs-  #{ es_data_keys - data_keys} "
       
          unless es_data.keys.sort == data.keys.sort
          #  assert_equal(es_data.keys.sort, data.keys.sort)
          end

          #fields = es_data_keys.intersection(data_keys)
          fields = es_data_keys

          #pp fields
          #pp "--  es_data[:translator] --"
          #pp process_field( es_data[:translator] )
          #pp "--  data[:translator] --"
          #pp  process_field( data[:translator] )

          fields.select! { |f| ! exclude_fields.include?( f )  }

          fields.each do |field|
            unless es_data[field].nil? && data[field].nil?
              data_field = process_field( data[field] )
              es_data_field = process_field( es_data[field] )

              tested_fields << field

              unless data_field == es_data_field || ( data_field =="" && es_data_field.nil? )

                if  test_results[data_field].nil?
                  test_results[field] = [lirias_id => {  "data_field" => data_field,"es_data_field" => es_data_field }]
                else
                  test_results[field] <<  [lirias_id => {  "data_field" => data_field,"es_data_field" => es_data_field }]
                end
              end
            end
          end

        end

        unless test_results.empty?
          pp "--------------------------"
          pp "/ Fields that or changed in #{lirias_id} /"
          pp "--------------------------"
          pp test_results.keys
          pp ""
          pp "--------------------------"
          pp test_results
          pp "--------------------------"
        end
        assert_equal(test_results, {})
        test_results={}
      end


=begin
      pp ""
      pp "-----------------------"
      pp "/ Fields in this test /"
      pp "-----------------------"
      pp tested_fields.flatten
=end

     
      assert_equal(test_results, {})

    end
    
end

