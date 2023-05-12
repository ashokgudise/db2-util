#!/bin/bash

# Uncomment for DEBUG.
# set -x

if [ $(id -u) != 510 ];
        then echo "You must be db2inst1 to run this script."
        exit 1
fi

# Check existing members are started.
MEMBER=$(db2instance -list -member | sed '1,2d;$d' | awk '{print $3,$4}')
        while read -r MEMBER; do
                STATUS="$(echo $MEMBER | awk '{print $1}')"
                if [[ $STATUS = "STARTED" ]]; then
                        echo "$(echo $MEMBER | awk '{print $2}') currently in state $STATUS."
                else
                        echo "$(echo $MEMBER | awk '{print $2}') not STARTED, current state is $STATUS."
                        exit 100
                fi
        done <<< "$MEMBER"
exit
