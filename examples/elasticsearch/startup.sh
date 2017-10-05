#!/bin/bash

ES_DATA=/opt/elasticsearch/esdata
HOST_IP=10.50.100.5
ES_PORT=9200
sysctl -w vm.max_map_count=262144

mkdir -p $ES_DATA

docker stop elasticsearch
docker rm elasticsearch
docker run -d \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  -v $ES_DATA:/usr/share/elasticsearch/data \
  --restart always \
  --name elasticsearch \
  quay.io/pires/docker-elasticsearch-kubernetes:5.5.2

sleep 20s

curl
# check health
curl http://$(HOST_IP):$(ES_PORT)/_cat/indices?v
#
docker stop kibana
docker rm kibana
docker run -d \
  -e "ELASTICSEARCH_URL=http://$(HOST_IP):$(ES_PORT)" \
  -p 5602:5601 \
  --name kibana \
  kibana:5.5.2

sleep 5s
docker logs kibana

  #-v /opt/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \

  #docker.elastic.co/kibana/kibana:5.6.2
