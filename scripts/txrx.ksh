#!/bin/bash

INTERVAL="1"  # update interval in seconds

if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        echo shows packets-per-second
        exit
fi

printf "====================================================\n"
printf "TIME                      TX      RX   TXBPS   RXBPS\n"
printf "                          ps      ps    kbps    kbps\n"
printf "====================================================\n"

while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_packets`
        T1=`cat /sys/class/net/$1/statistics/tx_packets`
        B1=`cat /sys/class/net/$1/statistics/rx_bytes`
        C1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_packets`
        T2=`cat /sys/class/net/$1/statistics/tx_packets`
        B2=`cat /sys/class/net/$1/statistics/rx_bytes`
        C2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TXPPS=`expr $T2 - $T1`
        RXPPS=`expr $R2 - $R1`
        TBPS=`expr $C2 - $C1`
        RBPS=`expr $B2 - $B1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        TIME=$(date +%Y-%m-%d-%H:%M:%S)
        printf "%-20s %7d %7d %7d %7d\n" $TIME $TXPPS $RXPPS $TKBPS $RKBPS
done
