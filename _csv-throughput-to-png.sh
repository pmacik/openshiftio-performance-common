#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR/png
INPUT=$1
NAME=`echo $INPUT | xargs -I{} basename {} | sed -e 's,\.csv,,g'`

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Throughput"
set output "$LOG_DIR/png/$NAME-throughput.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "req/s"
set grid
plot "$INPUT" u 1:8 t "Average"
eor