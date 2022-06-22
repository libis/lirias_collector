#!/usr/bin/env bash
docker-compose run --rm lirias_collector cd /app/src/; ruby collector.rb rules/lirias_rules.rb >> ../logs/lirias_collector.log 2>&1




