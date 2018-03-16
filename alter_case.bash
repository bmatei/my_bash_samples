#!/bin/bash

INPUT=""
OUTPUT=""
if [ $# -eq 1 ]
	then
	INPUT=$1
	OUTPUT=$1
elif [ $# -eq 2 ]
	then
	INPUT=$1
	OUTPUT=$2
else
	echo "Usage: $0 <file> or $0 <source> <dest>"
	exit 1
fi

if [ ! -f $INPUT ]
	then
	echo "$INPUT does not exist or is not regular file"
fi

REZ=$(tr '[:lower:]' '[:upper:]' < $INPUT)
echo "$REZ" > $OUTPUT