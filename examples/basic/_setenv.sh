#!/bin/bash

# 'true" if locust test is to be run locally (i.e. no master, no slaves, no remote execution).
export RUN_LOCALLY=false

# Should be provided by Jenkins.
export JOB_BASE_NAME=example

# Should be provided by Jenkins.
export BUILD_NUMBER=1

# A name of the directory where logs and reports are placed during the test execution
export LOG_DIR=$JOB_BASE_NAME-$BUILD_NUMBER-logs

# Server url
export SERVER_HOST=http://httpbin.org

# Locust SSH user. (Only for RUN_LOCALLY != true)
export SSH_USER=centos

# Locust node workdir. (Only for RUN_LOCALLY != true)
export SSH_WORKDIR=/var/osioperf

# Locust MASTER node. (Only for RUN_LOCALLY != true)
export MASTER_HOST=osioperf-server-2

# A number of Locust slaves to use. (Only for RUN_LOCALLY != true)
export SLAVES=2

# A prefix for a Locust slave node address. (Only for RUN_LOCALLY != true)
export SLAVE_PREFIX=osioperf-client-

# A number of users to spawn.
export USERS=2

# A hatch rate (number of users to spawn per second).
export USER_HATCH_RATE=2

# A name of the property file with username=password list of users to be logged in
export USERS_PROPERTIES_FILE=users.properties

# A file where USERS_PROPERTIES environmental variable is supposed to be set.
# This file is copied to locust master/slaves to be sources by BASH before executing the locust itself.
# So the locust process get's passed the USERS_PROPERTIES variable.
export ENV_FILE=/tmp/osioperftest.users.env

# 'true' if a report will be sent to a Zabbix instance
export ZABBIX_REPORT_ENABLED=false

# An address of Zabbix server
#export ZABBIX_SERVER=zabbix.devshift.net

# A port of Zabbix server used by zabbix_sender utility
#export ZABBIX_PORT=10051

# A hostname in Zabbix the report is for
export ZABBIX_HOST=zabbix-host

# A number of seconds for how long the test should run
export DURATION=60

export REPORT_CHART_WIDTH=1000
export REPORT_CHART_HEIGHT=600

export README_FILE=README.md

export METRIC_META_FILE=_metrics.meta