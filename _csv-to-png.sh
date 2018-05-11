#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR/png

INPUT=$1
TITLE=$2
X_LABEL=$3
Y_LABEL=$4
NAME=`echo $INPUT | xargs -I{} basename {} | sed -e 's,\.csv,,g'`

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$TITLE"
set output "$LOG_DIR/png/$NAME.png"
set style data line
set yrange [0:*]
set xdata time
set timefmt '%Y-%m-%d %H:%M:%S'
set format x "%Y\n%m-%d\n%H:%M:%S"
set datafile separator ";"
set xlabel "$X_LABEL"
set ylabel "$Y_LABEL"
set grid
plot "$INPUT" u 1:2 w linespoints t ""
eor