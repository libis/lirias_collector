require "test_helper"

DEBUG_TEST = true



# $ grep "lirias_ids =" parsing_test.rb  | cut -d "=" -f 2 | sed 's/\[//' |  sed 's/\]/,/'
=begin
lirias_ids = [ 1769877, 1128655, 1100345]
pp lirias_ids.sort.uniq

=end


fields = [:author,  :editor, :contributors, :translator, :supervisor,  :co_supervisor]
@@excludefields= [:es_created, :es_updated ]

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
  4080935]




class DataCollectorInputTest < Minitest::Test
    
    def test_all
      lirias_ids =@@lirias_test_ids
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

          fields.select! { |f| ! @@excludefields.include?( f )  }

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
        pp "-----------------------"
      end


=begin
      pp ""
      pp "-----------------------"
      pp "/ Fields in this test /"
      pp "-----------------------"
      pp tested_fields.flatten
=end

      pp ""
      pp "--------------------------"
      pp "/ Fields that or changed /"
      pp "--------------------------"
      pp test_results.keys
      pp ""
      pp "--------------------------"
      pp test_results
      pp "--------------------------"
      
      assert_equal(test_results, {})

    end
    
end

