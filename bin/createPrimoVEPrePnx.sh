
#!/usr/bin/env bash
# docker-compose -f ./docker-compose.yml run -u 504:503 --rm lirias_collector bash -c "cd /app/src/; ruby collector.rb rules/primo_VE_lirias_rules.rb" >> ../logs/lirias_collector_primove.log 2>&1
docker-compose run --rm lirias_collector bash -c "cd /app/src/; ruby collector.rb rules/primo_VE_lirias_rules.rb" >> ../logs/lirias_collector_primove.log 2>&1
