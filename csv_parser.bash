#!/bin/bash

#usage test
if [ $# -lt 1 ]
then
	echo "Usage: $0 <csv file>"
	exit 1
fi

#file exists? what's it's name on disk?
if [ ! -f $1 ]
then
	if [ ! -f "$1.csv" ]
	then
		echo "$1 does not exist or is not a regular file"
		exit 1
	else
		FILE="$1.csv"
	fi
else
	FILE="$1"
fi

#debug
#echo $FILE

#cat $FILE | read VAR
exec 3< $FILE

LINE=""
OUT=""
while read LINE <&3
do
	IP=$(echo $LINE | cut -d , -f 1)
	MAC=$(echo $LINE | cut -d , -f 2 | \
		sed 's/\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)\(\w\w\)/\1:\2:\3:\4:\5:\6/' |\
		tr '[:lower:]' '[:upper:]')
	CALC=$(echo $LINE | cut -d , -f 3)
	OUT+="host $CALC {\n\toption host-name \"$CALC\";\n\thardware ethernet $MAC;\n\tfixed-address $IP;\n}\n"
done

if [ $# -ge 2 ]
then
	exec 1> $2
fi

echo -e "$OUT"

exec 3>&-
exec 1>&-



