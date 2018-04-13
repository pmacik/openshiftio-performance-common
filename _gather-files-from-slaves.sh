#!/bin/bash
set -x
#source _setenv.sh

PATTERN=${1:-$JOB_BASE_NAME-$BUILD_NUMBER-*}

for i in $(seq 1 $SLAVES); do
	mkdir -p slave-$i
	scp $SSH_USER@$SLAVE_PREFIX$i:$SSH_WORKDIR/$PATTERN slave-$i/;
done


