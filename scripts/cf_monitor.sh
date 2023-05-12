#!/bin/bash

# Uncomment for DEBUG.
set -x

if [ $(id -u) != 510 ];
        then echo "You must be db2inst1 to run this script."
        exit 1
fi

# Check existing CF's are started.
CF=$(db2instance -list -cf | sed '1,2d;$d' | awk '{print $3,$4}')
        while read -r CF; do
                STATUS="$(echo $CF | awk '{print $1}')"
                if [[ $STATUS = "PRIMARY" ]] || [[ $STATUS = "PEER" ]]; then
                        echo "$(echo $CF | awk '{print $2}') currently in state $STATUS."
                elif  [[ $STATUS = "CATCHUP" ]]; then
                        echo "$(echo $CF | awk '{print $2}') currently in state $STATUS."
                else
                        echo "$(echo $CF | awk '{print $2}') not in state PRIMARY, PEER, or CATCHUP, current state is $STATUS."
                        exit 100
                fi
        done <<< "$CF"
exit
