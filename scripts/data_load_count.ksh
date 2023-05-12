#!/bin/bash
prevRows=0
while true
do
rows=$(db2 list utilities show detail | grep -E 'Completed Work.*rows' | awk '{sum+=$4} END {print sum}')
start_time="$(date -u +%s)"
if [[ "$rows" == "" ]] ; then
echo "No rows. Exiting ..."
break;
else
rateRows="$(bc <<< "scale=2; ($rows-$prevRows)/5")"
printf "$(date +'%Y-%m-%d %H:%M:%S') Total Rows %'9.0f Rate %9.2f per seconds\n" \
$rows $rateRows
fi
sleep 5
end_time="$(date -u +%s)"
prevRows=$rows
done
