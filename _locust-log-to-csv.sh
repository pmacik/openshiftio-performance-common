#!/bin/bash

#source _setenv.sh

METRIC=$1;
INPUT=$2;
OUTPUT=${3-$JOB_BASE_NAME-$BUILD_NUMBER-`echo $METRIC | sed -e 's,[ /?:]\+,_,g'`.csv};

echo $OUTPUT
echo -n "" > $OUTPUT

header="TimeInSeconds;"`cat $INPUT | grep "Name" | head -n 1 | sed -e 's,\s\s*|\?\s\+,;,g' | cut -d ";" -f 2-8`;

cat $INPUT | while read line; do
	if [[ $line == "Percentage of the requests completed within given times"* ]]; then
		break;
	else
		grep -F "$METRIC" | sed -e 's,|,,g' | sed -e 's,\s\+,;,g' | sed -e 's,([0-9]\+\.[0-9]\+%),,g' | cut -d ";" -f 4-9 >> $$-$OUTPUT;
	fi
done

pseudo_now=$DURATION
tac $$-$OUTPUT | while read line; do
	echo "$pseudo_now;$line" >> $$-$OUTPUT.new
	pseudo_now=`expr $pseudo_now - 2`
done

echo $header>$OUTPUT
tac $$-$OUTPUT.new >> $OUTPUT

rm -rf $$-*