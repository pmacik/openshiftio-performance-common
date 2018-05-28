#!/bin/bash

source _setenv.sh

# Path to the root of Common
export COMMON="../../"
source $COMMON/config/_setenv.sh

./_prepare_locustfile.sh $JOB_BASE_NAME.py

$COMMON/_execute.sh
