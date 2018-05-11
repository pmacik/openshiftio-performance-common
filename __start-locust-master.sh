#!/bin/bash

#source _setenv.sh

LOCUST_FILE=${1:-osioperf.py}

if [ -f $LOCUST_FILE ]; then
	scp $LOCUST_FILE $SSH_USER@$MASTER_HOST:$SSH_WORKDIR/$JOB_BASE_NAME-$BUILD_NUMBER-locustfile.py;
	ssh $SSH_USER@$MASTER_HOST "chmod u+w $SSH_WORKDIR/users.env"
	scp $ENV_FILE-master $SSH_USER@$MASTER_HOST:$SSH_WORKDIR/users.env
	CMD="rm -rf $SSH_WORKDIR/$LOG_DIR; mkdir -p $SSH_WORKDIR/$LOG_DIR/csv; nohup locust -f $JOB_BASE_NAME-$BUILD_NUMBER-locustfile.py --master --no-web --print-stats --no-reset-stats --expect-slaves=$SLAVES --clients=$USERS --hatch-rate=$USER_HATCH_RATE --csv=$SSH_WORKDIR/$LOG_DIR/csv/$JOB_BASE_NAME-$BUILD_NUMBER-report 2>$SSH_WORKDIR/$LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log > $SSH_WORKDIR/$LOG_DIR/$JOB_BASE_NAME-$BUILD_NUMBER-locust-master.log &";
	echo "Starting a master at $MASTER_HOST: $CMD";
	echo $CMD >> $$-master;
	ssh $SSH_USER@$MASTER_HOST "source $SSH_WORKDIR/users.env; bash -s" < $$-master;
	rm -rf $$-master;
else
	echo "$LOCUST_FILE not found";
	exit 1;
fi


