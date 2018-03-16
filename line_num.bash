#!/bin/bash
i=1;
while read test
do
	echo "$i '$test'"
	i=$(($i+1))
done < $1
