#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR
scp -r $SSH_USER@$MASTER_HOST:"$SSH_WORKDIR/$LOG_DIR/*" $LOG_DIR/;
