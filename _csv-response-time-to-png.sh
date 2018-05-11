#!/bin/bash

#source _setenv.sh

mkdir -p $LOG_DIR/png

INPUT=$1
NAME=`echo $INPUT | xargs -I{} basename {} | sed -e 's,\.csv,,g'`

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Response Time Stats"
set output "$LOG_DIR/png/$NAME-response-time.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "ms"
set grid
plot "$INPUT" u 1:4 t "Average", "$INPUT" u 1:5 t "Min", "$INPUT" u 1:6 t "Max", "$INPUT" u 1:7 t "Median"
eor

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Minimal-Response Time"
set output "$LOG_DIR/png/$NAME-minimal-response-time.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "ms"
set grid
plot "$INPUT" u 1:5 t "Min"
eor

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Median Response Time"
set output "$LOG_DIR/png/$NAME-median-response-time.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "ms"
plot "$INPUT" u 1:7 t "Median"
eor

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Maximal Response Time"
set output "$LOG_DIR/png/$NAME-maximal-response-time.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "ms"
plot "$INPUT" u 1:6 t "Max"
eor

gnuplot << eor
set terminal png size $REPORT_CHART_WIDTH, $REPORT_CHART_HEIGHT noenhanced
set title "$NAME Average Response Time"
set output "$LOG_DIR/png/$NAME-average-response-time.png"
set style data line
set yrange [0:*]
set datafile separator ";"
set xlabel "Time [s]"
set ylabel "ms"
plot "$INPUT" u 1:4 t "Average"
eor
