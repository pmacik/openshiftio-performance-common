#!/bin/bash

mkdir -p $LOG_DIR

export ZABBIX_TIMESTAMP=`date +%s`

function filterZabbixValue {
   cat $1 | grep " $2" | head -n 1 | cut -d " " -f 4
}

for i in `cat $METRIC_META_FILE`; do
	if [ "${i:0:1}" != "#" ]; then
		metric_meta=(`echo $i | tr ";" " "`)
		metric_request_type=${metric_meta[0]}
		metric_name=${metric_meta[1]}
		zabbix_metric_prefix="$ZABBIX_TESTSUITE_PREFIX.$metric_request_type.$metric_name"

		#@@GENERATE_FILTER_ZABBIX_VALUE@@
		V_MIN=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-rt_min"`;
		V_MED=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-rt_median"`;
		V_MAX=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-rt_max"`;
		V_AVG=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-rt_average"`;
		V_FAILED=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-failed"`;
		V_PASSED=`filterZabbixValue $ZABBIX_LOG "$zabbix_metric_prefix-passed"`;

		#@@GENERATE_LOAD_TEST_TABLE@@
		if [[ -z $ltt ]]; then
			ltt="$ltt| $metric_request_type.$metric_name | $V_MIN ms | $V_MED ms | $V_MAX ms | $V_PASSED | $V_FAILED |"
		else
			ltt="$ltt\n| $metric_request_type.$metric_name | $V_MIN ms | $V_MED ms | $V_MAX ms | $V_PASSED | $V_FAILED |"
		fi

		#@@GENARATE_LOAD_TEST_CHARTS@@
		ltch="$ltch\n#### \`$metric_name\` Response Time"
		ltch="$ltch\n![$metric_name-reponse-time](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-response-time.png)"
		ltch="$ltch\n![$metric_name-minimal-reponse-time](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-minimal-response-time.png)"
		ltch="$ltch\n![$metric_name-median-reponse-time](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-median-response-time.png)"
		ltch="$ltch\n![$metric_name-maximal-reponse-time](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-maximal-response-time.png)"
		ltch="$ltch\n![$metric_name-average-reponse-time](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-average-response-time.png)"
		ltch="$ltch\n![$metric_name-rt-histo](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-rt-histo.png)"
		ltch="$ltch\n#### \`$metric_name\` Failures"
		ltch="$ltch\n![$metric_name-failures](./png/$JOB_BASE_NAME-$BUILD_NUMBER-$metric_request_type""_$metric_name-failures.png)"
   fi
done

export RESULTS_FILE=$LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-results.md
cp -rvf $COMMON/results-template.md $RESULTS_FILE

REPORT_TIMESTAMP=`date '+%Y-%m-%d %H:%M:%S (%Z)'`
sed -i -e "s,@@TIMESTAMP@@,$REPORT_TIMESTAMP,g" $RESULTS_FILE
sed -i -e 's,@@GENERATE_LOAD_TEST_TABLE@@,'"$ltt"',g' $RESULTS_FILE
sed -i -e 's,@@GENARATE_LOAD_TEST_CHARTS@@,'"$ltch"',g' $RESULTS_FILE
sed -i -e "s,@@JOB_BASE_NAME@@,$JOB_BASE_NAME,g" $RESULTS_FILE
sed -i -e "s,@@BUILD_NUMBER@@,$BUILD_NUMBER,g" $RESULTS_FILE


REPORT_FILE=$LOG_DIR/$JOB_BASE_NAME-report.md
cat $README_FILE $RESULTS_FILE > $REPORT_FILE
if [ -z "$GRIP_USER" ]; then
	grip --export $REPORT_FILE
else
	grip --user=$GRIP_USER --pass=$GRIP_PASS --export $REPORT_FILE
fi