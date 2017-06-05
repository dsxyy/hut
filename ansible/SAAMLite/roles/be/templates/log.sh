#!/bin/bash
#set -x

collectPID=`ps -A |grep logstash | awk '{print $1}'`
echo "PID:"$collectPID
len=${#collectPID}
date
if [ $len -gt 0 ];then
	sleep 60;
fi

cd /var/log/NPM/
ls *.gz |gawk -F".gz" '{print $1}'>/tmp/tmplog.log

while read LINE
do
	echo $LINE
	A=`ls -lrt |grep ${LINE} |wc -l`
	#echo A $A
	if [ ${A} == 1 ]
	then
		find /var/log/NPM/${LINE}.gz -exec mv {} /var/log/NPM/backup/ \;
	fi
done </tmp/tmplog.log
rm -rf /tmp/tmplog.log

find /var/log/NPM/backup/ -mtime +60 -name "*.gz" -exec rm -rf {} \;
find /var/opt/csic/trace -mtime +10 -name "*.*" -exec rm -rf {} \;
#find /var/logstash/partionDelete -mtime +60 -name "*.*" -exec rm -rf {} \;
date