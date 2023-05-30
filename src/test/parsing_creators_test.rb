require "test_helper"

DEBUG_TEST = false



# $ grep "lirias_ids =" parsing_test.rb  | cut -d "=" -f 2 | sed 's/\[//' |  sed 's/\]/,/'
=begin
lirias_ids = [ 1769877, 1128655, 1100345]
pp lirias_ids.sort.uniq

=end

lirias_ids = [1128655, 1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606]
fields = [:author,  :editor, :contributors, :translator, :supervisor,  :co_supervisor]

@@lirias_test_ids = [1128655, 1822382, 1685129, 1685400, 1928278, 1403090, 71653, 1694043, 2788749, 1815226, 1815248, 3791606, 1815226]


# lirias1822382 supervisor and co_supervisor and author (GEEN contributors)
# lirias1685129 contributors (Architect, Curator, Editor) roles 1685129
# lirias1685400 contributors with roles 1685400
# lirias1928278 contributors without roles and not available in editor,translator,supervisor, ... 
# lirias1403090 editor 
# lirias1685129 c-editor 
# lirias71653 editor ==> ???? author met achternaam Yeh (Editor) ????
# lirias1694043 authors with role editor which are duplicated in c-editor 
# lirias2788749 translator 
# lirias1815226 contributors without roles/functions and duplicated in editor and translator 
# lirias1815248 book_series_editor  
# lirias3791606 strange author role 

class DataCollectorInputTest < Minitest::Test

    def test_author
    
      lirias_ids = @@lirias_test_ids
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
      lirias_ids = @@lirias_test_ids
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
      lirias_ids = @@lirias_test_ids
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
      lirias_ids = @@lirias_test_ids
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
      lirias_ids = @@lirias_test_ids
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
      lirias_ids = @@lirias_test_ids
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



    
end

