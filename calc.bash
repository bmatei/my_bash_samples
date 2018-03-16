#!/bin/bash

#func file test
if [ ! -f m_func.bash ]
then
	echo "Missing mathematical functions file (m_func.bash)."
	exit 1
fi

#usage test
if [ $# -ne 2 ]
then
	echo "Usage: $0 <op1> <op2>"
	exit 1
fi

#remove awkward characters
A=$(echo "$1" | sed s/[^0-9]//)
B=$(echo "$2" | sed s/[^0-9]//)

#load funcs
. m_func.bash

#menu declaration
function printm(){
	dialog 	--backtitle "Matei's Calculator"			\
			--radiolist "$1 ? $2" 20 100 5				\
			+ "? = +" on - "? = -" off \* "? = *" off	\
			/ "? = /" off % "? = %" off 2>/tmp/diag_out
	
	clear		
	REZ=$(cat /tmp/diag_out)
	rm /tmp/diag_out
	case $REZ in
		+)	return 1;;
		-)	return 2;;
		\*)	return 3;;
		/)	return 4;;
		%)	return 5;;
	esac
	return 0
	
}

#show menu
printm $A $B

#decide course of action
case $? in
	1)	
		m_add $A $B REZ
		echo "($A) + ($B) = $REZ"
	;;
	2)
		m_sub $A $B REZ
		echo "($A) - ($B) = $REZ"
	;;
	3)
		m_mul $A $B REZ
		echo "($A) * ($B) = $REZ"
	;;
	4)
		if [ $B -eq 0 ]
		then
			echo "Sorry, can't divide by 0"
			exit 1
		fi
		m_div $A $B REZ
		if [ $(($A/$B)) -eq 0 ]				#fix bc output when result is between (-1, 1)
		then
			if [ "${REZ:0:1}" = "-" ]
			then
				REZ="-0${REZ:1:${#REZ}}"
			else
				REZ="0$REZ"
			fi
		fi
		echo "($A) / ($B) = $REZ"
	;;
	5)
		m_mod $A $B REZ
		echo "($A) % ($B) = $REZ"
	;;
	0)
		echo "Bye bye"
	;;
esac