

Steps to recreate ELK

1)
docker run --name es -d -p 9200:9200 elasticsearch

2)
docker run --name kibana --link es:es -d -p 5601:5601 -e ELASTICSEARCH_URL=http://es:9200 jimmidyson/kibana4:latest

3.1)
docker run --name logstash -d --link es:es -v "$PWD":/config-dir logstash logstash --verbose --config /config-dir/logstash.conf

3.2)
docker exec -d logstash bash -C '/config-dir/get_sample.sh'



#"%a %l %u %t \"%r\" %>s %b %D"
# %a  Remote IP-address
# %l  Remote logname (from identd, if supplied). This will return a dash unless mod_ident is present and IdentityCheck is set On.
# %u  Remote user (from auth; may be bogus if return status (%s) is 401)
# %t  Time the request was received (standard english format)
# %r  First line of request
# %s  Status. For requests that got internally redirected, this is the status of the *original* request --- %>s for the last.
# %b  Size of response in bytes, excluding HTTP headers. In CLF format, i.e. a '-' rather than a 0 when no bytes are sent.
# %D  The time taken to serve the request, in microseconds.



curl 192.168.59.103:9200/_cluster/health?pretty=true
curl es:9200/_cluster/health?pretty=true
curl 192.168.59.103:9200/_nodes/_local
curl -XPUT 'http://192.168.59.103:9200/twitter/
curl 192.168.59.103:9200/_stats?pretty=true

docker run -it --rm -v "$PWD":/config-dir logstash logstash -f /config-dir/logstash.conf






