
#!/usr/bin/env bash
docker-compose run --rm lirias_collector cd /app/src/; ruby collector.rb rules/primo_VE_lirias_rules.rb >> ../logs/lirias_collector_primove.log 2>&1
