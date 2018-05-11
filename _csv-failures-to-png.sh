#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR/png

INPUT=$1
NAME=`echo $INPUT | xargs -I{} basename {} | sed -e 's,\.csv,,g'`

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Failures"
set output "$LOG_DIR/png/$NAME-failures.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "# of Failures"
set grid
plot "$INPUT" u 1:3 t "# of failures"
eor