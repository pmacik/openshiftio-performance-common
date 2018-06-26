#!/bin/bash

mkdir -p $LOG_DIR

function distribution_2_csv {
	HEAD=(`cat $1 | head -n 1 | sed -e 's,",,g' | sed -e 's, ,_,g' | sed -e 's,%,,g' | tr "," " "`)
	DATA=(`cat $1 | grep -F "$2" | sed -e 's,",,g' | sed -e 's, ,_,g' | tr "," " "`)
	NAME=`echo $1 | sed -e 's,.*/csv/\(.*\)-report_distribution.csv,\1,g'`-`echo "$2" | sed -e 's,",,g' | sed -e 's, ,_,g;'`

	rm -rf $LOG_DIR/csv/$NAME-rt-histo.csv;
	for i in $(seq 2 $(( ${#HEAD[*]} - 1 )) ); do
		echo "${HEAD[$i]};${DATA[$i]}" >> $LOG_DIR/csv/$NAME-rt-histo.csv;
	done;
}

for i in `cat $METRIC_META_FILE`; do
	if [ "${i:0:1}" != "#" ]; then
		metric_meta=(`echo $i | tr ";" " "`)
		metric_request_type=${metric_meta[0]}
		metric_name=${metric_meta[1]}

		for c in $(find $LOG_DIR/csv -name '*-report_distribution.csv'); do
			distribution_2_csv $c "$metric_request_type $metric_name";
		done
   fi
done
