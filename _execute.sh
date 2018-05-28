#!/bin/bash

echo " Prepare user environments"

if [ "$RUN_LOCALLY" != "true" ]; then
	rm -rf $ENV_FILE-slave-*
fi
rm -rf $ENV_FILE-master
if [ -f $USERS_PROPERTIES_FILE ]; then
	$COMMON/_prepare_users.sh
fi

echo " Prepare additional environment"
if [ -f $WORKSPACE/_prepare_env.sh ]; then
	$WORKSPACE/_prepare_env.sh
fi

echo " Prepare locust file"
if [ ! -f osioperf.py ]; then
	$COMMON/_prepare_locustfile.sh $JOB_BASE_NAME.py
fi

if [ "$RUN_LOCALLY" != "true" ]; then
	echo " Shut Locust master down"
	$COMMON/__stop-locust-master.sh

	echo " Shut Locust slaves down"
	SLAVES=10 $COMMON/__stop-locust-slaves.sh

	echo " Start Locust master waiting for slaves"
	$COMMON/__start-locust-master.sh

	echo " Start all the Locust slaves"
	$COMMON/__start-locust-slaves.sh
else
	echo " Shut Locust down"
	$COMMON/__stop-locust-master-standalone.sh
	echo " Run Locust locally"
	$COMMON/__start-locust-master-standalone.sh
fi

echo " Run test for $DURATION seconds"
sleep $DURATION

if [ "$RUN_LOCALLY" != "true" ]; then
	echo " Shut Locust master down"
	$COMMON/__stop-locust-master.sh TERM

	echo " Download locust reports from Locust master"
	$COMMON/_gather-locust-reports.sh

	echo " Download files from slaves"
	$COMMON/_gather-files-from-slaves.sh
else
	echo " Shut Locust down"
	$COMMON/__stop-locust-master-standalone.sh TERM
fi

echo " Extract CSV data from logs"
$COMMON/_batch_locust_log_to_csv.sh

echo " Generate charts from CSV"
$COMMON/_batch_csv_to_png.sh
$COMMON/_batch_distribution_to_csv.sh
for c in $(find $LOG_DIR/csv -name '*rt-histo.csv'); do
	echo $c;
	$COMMON/_csv-rt-histogram-to-png.sh $c;
done

echo " Prepare results for Zabbix"
rm -rvf *-zabbix.log
export ZABBIX_LOG=$LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-zabbix.log
$COMMON/_batch_zabbix_process_load.sh

if [[ "$ZABBIX_REPORT_ENABLED" = "true" ]]; then
	echo "  Uploading report to zabbix...";
	zabbix_sender -vv -i $ZABBIX_LOG -T -z $ZABBIX_SERVER -p $ZABBIX_PORT;
fi

echo " Create HTML report"
$COMMON/_batch_results_report.sh

if [ "$RUN_LOCALLY" != "true" ]; then
	echo " Shut Locust slaves down"
	$COMMON/__stop-locust-slaves.sh
fi

echo " Check for errors in Locust master log"
if [[ "0" -ne `cat $LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log | grep 'Error report' | wc -l` ]]; then echo '[:(] THERE WERE ERRORS OR FAILURES!!!'; else echo '[:)] NO ERRORS OR FAILURES DETECTED.'; fi
