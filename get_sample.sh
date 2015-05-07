#!/bin/bash
set -x

DOWNLOAD_URL="https://s3-eu-west-1.amazonaws.com/skyscanner-hiring/sample-access-log/c930ecf4b0a4426e619bddd8752c475ea772427db13eb92ee6a1a79b248ec0dc/web-access.log"
LOG_FOLDER="/logs"

#
# Will download file in parts, so we get entries in ES and some data on kibana dashboard as fast as possible
#
mkdir $LOG_FOLDER
curl -r 0-1000000 -o $LOG_FOLDER/web-access_short_0_1MB.log $DOWNLOAD_URL
curl -r 1000000-10000000 -o $LOG_FOLDER/web-access_short_1_10MB.log $DOWNLOAD_URL
curl -r 10000000- -o $LOG_FOLDER/web-access_short_10_allMB.log $DOWNLOAD_URL

chown -R logstash:logstash $LOG_FOLDER