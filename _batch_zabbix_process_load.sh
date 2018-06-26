#!/bin/bash

mkdir -p $LOG_DIR

export ZABBIX_TIMESTAMP=`date +%s`

for i in `cat $METRIC_META_FILE`; do
	if [ "${i:0:1}" != "#" ]; then
		metric_meta=(`echo $i | tr ";" " "`)
		metric_request_type=${metric_meta[0]}
		metric_name=${metric_meta[1]}
		zabbix_metric_prefix="$ZABBIX_TESTSUITE_PREFIX.$metric_request_type.$metric_name"

		#@@GENERATE_ZABBIX_PROCESS_LOAD@@
		$COMMON/__zabbix-process-load.sh "\"$metric_request_type\",\"$metric_name\"" "$zabbix_metric_prefix" >> $ZABBIX_LOG
   fi
done