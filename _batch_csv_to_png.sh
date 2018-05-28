#!/bin/bash

mkdir -p $LOG_DIR


for i in `cat $METRIC_META_FILE`; do
	if [ "${i:0:1}" != "#" ]; then
		metric_meta=(`echo $i | tr ";" " "`)
		metric_request_type=${metric_meta[0]}
		metric_name=${metric_meta[1]}
		metric_name_caps=`echo $metric_name | tr /a-z/ /A-Z/ | sed -e 's,-,_,g'`
		zabbix_metric_prefix="$JOB_BASE_NAME.$metric_request_type.$metric_name"

		#@@GENERATE_CSV_TO_PNG@@
		for c in $(find $LOG_DIR/csv -name '*.csv' | grep "\-$metric_request_type\_$metric_name"); do
			echo $c;
			$COMMON/_csv-response-time-to-png.sh $c;
			$COMMON/_csv-throughput-to-png.sh $c;
			$COMMON/_csv-failures-to-png.sh $c;
		done
   fi
done