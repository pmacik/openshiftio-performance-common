#!/bin/bash

mkdir -p $LOG_DIR


for i in `cat $METRIC_META_FILE`; do
	if [ "${i:0:1}" != "#" ]; then
		metric_meta=(`echo $i | tr ";" " "`)
		metric_request_type=${metric_meta[0]}
		metric_name=${metric_meta[1]}
		metric_name_caps=`echo $metric_name | tr /a-z/ /A-Z/ | sed -e 's,-,_,g'`
		zabbix_metric_prefix="$JOB_BASE_NAME.$metric_request_type.$metric_name"

		#@@GENERATE_LOCUST_LOG_TO_CSV@@
		$COMMON/_locust-log-to-csv.sh "$metric_request_type $metric_name" $LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log
   fi
done