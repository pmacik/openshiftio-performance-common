#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR/png

INPUT=$1
NAME=`echo $INPUT | xargs -I{} basename {} | sed -e 's,\.csv,,g'`

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Response Time Histogram"
set output "$LOG_DIR/png/$NAME.png"
set boxwidth 0.75
set style fill
set datafile separator ";"
set xtic rotate by -45 scale 0
set xlabel "Percentile [%]"
set ylabel "Response Time [ms]"
set yrange [0:*]
set grid
plot "$INPUT" using 2:xtic(1) with boxes t "", "" using 0:(\$2+15):(sprintf("%3.0f",\$2)) with labels t ""
eor
