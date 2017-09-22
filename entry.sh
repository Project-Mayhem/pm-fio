#!/bin/bash
#echo "Ensure the script to run: /home/fio/script.sh, is executable."
#chown fio:fio /home/fio/script.sh
#chmod u+x /home/fio/script.sh
chmod u+x -R /scripts/*.sh
# Become the fio user and run the fio test
#su -m fio -c /home/fio/script.sh

/bin/bash -c /scripts/script.sh