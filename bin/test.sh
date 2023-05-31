#!/usr/bin/env bash
docker-compose run --rm --build lirias_collector_develop bash 

=> rake test TEST=test/parsing_test.rb 
=> rake test TEST=test/parsing_creators_test.rb 
=> rake test TEST=test/parsing_delivery_test.rb 
=> rake test TEST=test/parsing_delivery_test.rb ESTOPTS="--name=test_linktorsrc -v"




