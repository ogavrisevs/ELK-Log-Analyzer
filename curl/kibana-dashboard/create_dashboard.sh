#!/bin/bash
set -x

sleep 20

HOST="es2"

curl -XDELETE http://$HOST:9200/.kibana
curl -XPUT http://$HOST:9200/.kibana
curl -XPUT http://$HOST:9200/.kibana/_mapping/config -d @mapping_config.json
curl -XPUT http://$HOST:9200/.kibana/_mapping/index-pattern -d @mapping_index-pattern.json
curl -XPUT http://$HOST:9200/.kibana/_mapping/dashboard -d @mapping_dashboard.json
curl -XPUT http://$HOST:9200/.kibana/_mapping/visualization -d @mapping_visualization.json
curl -XPUT http://$HOST:9200/.kibana/_mapping/search -d @mapping_search.json

curl -XPUT http://$HOST:9200/.kibana/visualization/1 -d @visualization_1.json
curl -XPUT http://$HOST:9200/.kibana/visualization/2 -d @visualization_2.json
curl -XPUT http://$HOST:9200/.kibana/visualization/3 -d @visualization_3.json
curl -XPUT http://$HOST:9200/.kibana/visualization/4 -d @visualization_4.json

curl -XPUT http://$HOST:9200/.kibana/dashboard/Cust-Dashboard -d @dashboard.json
curl -XPUT http://$HOST:9200/.kibana/index-pattern/logs -d @index-pattern.json
curl -XPUT http://$HOST:9200/.kibana/config/4.0.1 -d @config.json