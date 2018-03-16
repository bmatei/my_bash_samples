#!/bin/bash

#check usage
if [ $# -ne 1 ]
then
	echo "USAGE: $0 <program name>"
	exit 1
fi

#for readability
TARGET=$1

#load funcs
. cide_funcs.bash

#ask user if the file needs editing if the file exist
#if the file does not exist then it needs editing
if [ -e "$TARGET.c" ]
	then
	get_edit_yesno "$TARGET.c"
	EDIT=$?
else
	EDIT=0
fi

get_compiler_opts CFLAGS

#If user hits cancel then use no argument
if [ $? -ne 0 ]
then
	CFLAGS=""
fi

get_ipath IPATH

get_lpath LPATH

get_libs LIBS

#If the user must edit
if [ $EDIT -eq 0 ]
	then
	nano "$TARGET.c"
fi

#clear the screen
clear

#clean
rm -f $TARGET $TARGET.o $TARGET.err

#ask user for compiler output setting
COMPILER_OUT=""
get_binary_object COMPILER_OUT

#compile

if [ "$COMPILER_OUT" = "O" ]
then
	gcc $CFLAGS -c $IPATH $LPATH -o $TARGET.o "$TARGET.c" $LIBS &>"$TARGET.err"
else
	gcc $CFLAGS $IPATH $LPATH -o $TARGET "$TARGET.c" $LIBS &>"$TARGET.err"	
fi

#handle errors and run binary if possible
ERRS=$(cat "$TARGET.err")
if [ "$ERRS" != "" ]
	then
	echo "There were some errors/warnings. Here they are:"
	cat "$TARGET.err"
else
	echo "Compilation was successful"
fi

if [ "$COMPILER_OUT" = "B" ]
then
	if [ -e $TARGET ]
		then
		echo "Running $TARGET:"
		./$TARGET
	else
		echo "The $TARGET binary could not be created."
		echo "Check $TARGET.err"
	fi
fi

