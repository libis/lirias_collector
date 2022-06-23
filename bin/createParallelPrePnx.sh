#!/usr/bin/env bash
docker-compose run --rm lirias_collector bash -c "cd /app/src/; ruby collector.rb rules/lirias_parallel_rules.rb" >> ../logs/lirias_collector_parallel.log 2>&1



