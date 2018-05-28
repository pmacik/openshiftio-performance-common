#!/bin/bash

if [ "$RUN_LOCALLY" != "true" ]; then
	echo "export USERS_PROPERTIES=\"0=0\"
" >> $ENV_FILE-master;

	USER_COUNT=`cat $USERS_PROPERTIES_FILE | wc -l`
	i=1
	s=1
	rm -rf $USERS_PROPERTIES_FILE-slave-*;
	if [ $USER_COUNT -ge $SLAVES ]; then
		while [ $i -le $USER_COUNT ]; do
			sed "${i}q;d" $USERS_PROPERTIES_FILE >> $USERS_PROPERTIES_FILE-slave-$s;
			i=$((i+1));
			if [ $s -lt $SLAVES ]; then
				s=$((s+1));
			else
				s=1;
			fi;
		done;
	else
		while [ $s -le $SLAVES ]; do
			sed "${i}q;d" $USERS_PROPERTIES_FILE >> $USERS_PROPERTIES_FILE-slave-$s;
			s=$((s+1));
			if [ $i -lt $USER_COUNT ]; then
				i=$((i+1));
			else
				i=1;
			fi;
		done;
	fi
	for s in $(seq 1 $SLAVES); do
		echo "export USERS_PROPERTIES=\"$(cat $USERS_PROPERTIES_FILE-slave-$s)\"
" >> $ENV_FILE-slave-$s;
		echo ""
	done
else
	echo "export USERS_PROPERTIES=\"`cat $USERS_PROPERTIES_FILE`\"
" >> $ENV_FILE-master;
fi