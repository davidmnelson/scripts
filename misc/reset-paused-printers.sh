#!/bin/bash

/usr/bin/lpstat -p | /usr/bin/grep -EB1 "Paused" | /usr/bin/grep "^printer" | while read line; do

queue=`/bin/echo $line | /usr/bin/awk -F ' ' '{print $2}'`

	for job in `/usr/bin/lpq -a -P $queue | /usr/bin/awk -F ' ' '{if (NR>1) {print $3}}' | /usr/bin/grep -v "^Job"`; do
		/usr/bin/lprm $job ; 
	done

/usr/sbin/cupsenable $queue

done
