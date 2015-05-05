#!/bin/bash

DOWNLOAD_URL="https://dl.dropboxusercontent.com/u/399914/web-access_short.log"
LOG_FOLDER="/logs"

mkdir $LOG_FOLDER
curl -r 0-1000000 -o $LOG_FOLDER/web-access_short_0_1MB.log $DOWNLOAD_URL
curl -r 1000000-10000000 -o $LOG_FOLDER/web-access_short_1_10MB.log $DOWNLOAD_URL
curl -r 10000000- -o $LOG_FOLDER/web-access_short_10_allMB.log $DOWNLOAD_URL

chown -R logstash:logstash /logs