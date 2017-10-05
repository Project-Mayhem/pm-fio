#!/bin/bash

rm results.json
COUNTER=0
yourfilenames=`find ~/dev/meadowgate/rhlab/results/ -name *.out`
for eachfile in $yourfilenames
do
   echo "Processing file $eachfile"
   echo "{ \"create\" : { \"_index\" : \"fio5\", \"_type\" : \"fio\", \"_id\" : \"$COUNTER\" } }" >> results.json
   ./parse-fio.pl $eachfile >> results.json
   COUNTER=$[$COUNTER +1]
done

curl -s -H "Content-Type: application/x-ndjson" -XPOST 10.50.100.5:9200/_bulk --data-binary "@results.json"; echo
