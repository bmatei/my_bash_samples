#!/bin/bash

CONTENT=$(fortune)

for i in $(seq 0 ${#CONTENT})
do
	echo -n "${CONTENT:$i:1}"
	sleep 0.2
done

echo ""
