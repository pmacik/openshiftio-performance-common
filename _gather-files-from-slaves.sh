#!/bin/bash

#source _setenv.sh

PATTERN=${1:-$JOB_BASE_NAME-$BUILD_NUMBER-*}

for i in $(seq 1 $SLAVES); do
	mkdir -p $LOG_DIR/slave-$i
	scp -r $SSH_USER@$SLAVE_PREFIX$i:$SSH_WORKDIR/$PATTERN $LOG_DIR/slave-$i/;
done


