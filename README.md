Introduction
-----------------
This is proof of concept project. It demonstrates ELK stack (ElasticSearch + Logstash + Kibana) usage for analyzing application logs (apache as example ). For testing purposes we will spin-up on container apache reverse proxy. Stack is deployed on docker containers, `docker-compose` (ex fig) is used to control container work. Data across containers are shared with usage of volumes.

Versions and dependencies
-------------------------
Solution is tested on `Centos 6` with `docker 1.5.0` and `docker-compose 1.2.0`.

You can install `docker-compose` with :
```
sudo pip install -U docker-compose
```

And docker on Centos6 with:
```
sudo yum install docker-io
````

Full docker version :
  * Client version: 1.5.0
  * Client API version: 1.17
  * Go version (client): go1.3.3
  * Git commit (client): a8a31ef/1.5.0
  * OS/Arch (client): linux/amd64
  * Server version: 1.5.0
  * Server API version: 1.17
  * Go version (server): go1.3.3
  * Git commit (server): a8a31ef/1.5.0


URL's
----------------

To access kibana with pre-configured dashboard :

```
http://ip_of_docker_host:5601/#/dashboard/Cust-Dashboard
```

Also if you loaded sample data (see chapter "Load test data" ) you can access dashboard for particular data period:

```
http://ip_of_docker_host:5601/#/dashboard/Cust-Dashboard?_g=(time:(from:'2015-03-30',mode:absolute,to:'2015-03-31'))
```

Visit reverse proxy (on `cnn.com` site) (will generate new log entries and load to es in ~10 sec.):

```
http://ip_of_docker_host:8080
```

You can check es instance state :

```
http://ip_of_docker_host:9200/_cluster/health?pretty=true
```

Also if you loaded data with logstash you can check indice mapping and state with :

```
http://ip_of_docker_host:9200/_cluster/health?pretty=true
```


Commands
---------

To spin-up ELK stack :

```
git clone https://github.com/ogavrisevs/ELK-Log-Analyzer.git
cd ELK-Log-Analyzer
docker-compose up -d
```

Destroy ELK stack :

```
docker-compose stop
docker-compose rm
```

Also you can spin-up one container but its not possible to demonize it (detach process from stdout ) :

```
docker-compose up es
```

If something goes wrong you can inspect logs :

```
docker-compose logs
```
or find particular container name and :

```
docker ps --all
docker logs elkloganalyzer_logstash_1
```

##Testing with reverse proxy and loading test data

### Loading Test Data

You can load example data by executing folowing command (inspect precise container name with `docker ps `):

```
docker exec -d elkloganalyzer_logstash_1 bash -C '/config-dir/get_sample.sh'
```

This command will execute separate process in logstash container and download sample data from AWS s3. In nex 5s logstash should identify appearance of new log files and load them to es.

Install HQ plugin :

```
docker exec elkloganalyzer_es1_1 plugin -install royrusso/elasticsearch-HQ
```

### Apache reverse proxy
This solution provides one container with Apache reversed proxy to `cnn.com` site , if you visit this proxy it will generate log entries which will be picked up by logstash and displayed in kibana in about ~5 - 10 sec. For precise url please look for "URL's" paragraphs.


Boot2Docker usage on Mac OSX
-----------------------------
Due to bug (undocumented future ) straight out of box its not possible to user boot2ddocker because of shared folder mount permissions from boot2deocker VM to mac host allows only read access. So its not possible to persist data in volume. We use volume to persist ES db data with kibana config.


Kibana
-------
Kibana is used to visualized es stored data. Also kibana config is stored in es ( `.kibaba` indice ). Kibana is provided with one pre-configured dashboard and 4x visualizations with following info displayed:
 * No. of successful requests per minute
 * No. of error requests per minute
 * Mean response time per minute
 * MBs sent per minute


Logstash
--------
We use logstash for loading log files and applying es mapping to decrypted content. By default logstash applies `dynamic_templates` and almost all fields are string type. In this example we load our own field mapping (with integer field mapping), check file `template.json`. By default we are loading data in `logs` indice.  `Grok` is used as logstash filter to decrypt log filter.


Appache logs
------------

We assume logs will be provided from apache (mod_log_config)[http://httpd.apache.org/docs/2.2/mod/mod_log_config.html] in format :

````
"%a %l %u %t \"%r\" %>s %b %D"

 %a  Remote IP-address
 %l  Remote logname (from identd, if supplied). This will return a dash unless mod_ident is present and IdentityCheck is set On.
 %u  Remote user (from auth; may be bogus if return status (%s) is 401)
 %t  Time the request was received (standard english format)
 %r  First line of request
 %s  Status. For requests that got internally redirected, this is the status of the *original* request --- %>s for the last.
 %b  Size of response in bytes, excluding HTTP headers. In CLF format, i.e. a '-' rather than a 0 when no bytes are sent.
 %D  The time taken to serve the request, in microseconds.
```
