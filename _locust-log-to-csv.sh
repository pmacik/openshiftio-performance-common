#!/bin/bash

#source _setenv.sh

METRIC=$1;
INPUT=$2;
OUTPUT=${3-$LOG_DIR/csv/$JOB_BASE_NAME-$BUILD_NUMBER-`echo $METRIC | sed -e 's,[ /?:]\+,_,g'`.csv};
TMPFILE=$OUTPUT.tmp

echo $OUTPUT
echo -n "" > $OUTPUT

header="TimeInSeconds;"$(cat $INPUT | grep "Name" | head -n 1 | sed -e 's,\s\s*|\?\s\+,;,g' | cut -d ";" -f 2-8);

cat $INPUT | while read line; do
	if [[ $line == "Percentage of the requests completed within given times"* ]]; then
		break;
	else
		echo $line | grep -F "$METRIC" | sed -e "s,[\( \)\(|\)\]\+,;,g" | cut -d ";" -f 3-4,6-11 >> $$-$TMPFILE
	fi
done

pseudo_now=$DURATION
tac $$-$TMPFILE | while read line; do
	echo "$pseudo_now;$line" >> $$-$TMPFILE.new
	pseudo_now=$(expr $pseudo_now - 2)
done

echo $header>$OUTPUT
tac $$-$TMPFILE.new >> $OUTPUT

rm -rf $$-*