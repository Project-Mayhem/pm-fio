#!/bin/bash

DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
FILE="/data/${JOB_NAME}_$HOSTNAME_$DATE_WITH_TIME.out"
#SCP_TARGET_USERNAME=`cat $SCP_TARGET_USERNAME_FILE`
#SCP_TARGET_PASSWORD=`cat $SCP_TARGET_PASSWORD_FILE`

echo "set environment: `env`"
echo "----"
echo "Starting fio job"
/usr/bin/fio /config/job.fio --output=/data/$FILENAME
echo "Done with test."

rm -rf /data/test.data
cd /data
echo "Creating plots"
fio2gnuplot -b
fio2gnuplot -b -g
fio2gnuplot -i
fio2gnuplot -i -g
fio2gnuplot
fio2gnuplot -g
cd /
echo "creating archive: `echo $HOSTNAME`-test.tgz"
tar cvzf `echo $HOSTNAME`-test.tgz /data

echo "Moving file $FILE to host $TARGET_HOST"
echo "Connecting to host $SCP_TARGET_HOST as username $SCP_TARGET_USERNAME"
sshpass -p $SCP_PASSWORD_FILE scp -r $FILENAME $SCP_TARGET_USERNAME@$SCP_TARGET_HOST:$SCP_TARGET_PATH
