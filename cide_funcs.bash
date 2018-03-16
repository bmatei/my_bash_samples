

#First argument must be the filename
function get_edit_yesno(){
	dialog --backtitle "C IDE"						\
		--title "Hello $USER"						\
		--yesno "Do you want to edit $1?" 20 100	
	return $?
}

#First argument must be a holder for the resulted option
function get_binary_object(){
	if [ $# -eq 0 ]
	then
		return -1
	fi
	dialog --backtitle "C IDE"						\
		--title "Compiler setting"					\
		--radiolist "What do you want your compiler \
to produce?" 20 100 2 								\
		"B" "A binary" on 							\
		"O" "An object file" off 2>/tmp/diag_out
		OUT=$(cat /tmp/diag_out)
		if [ "$OUT" = "" ]
		then
			eval "$1='B'"
		else
			eval "$1='$OUT'"
		fi
		rm /tmp/diag_out
}


#First argument must be a holder for the resulted CFLAGS string
function get_compiler_opts(){
	if [ $# -eq 0 ]
	then
		return -1
	fi

	dialog 	--backtitle "C IDE"				\
		--title "Compiler options"			\
		--checklist "Check the options you 	\
want to pass to the compiler" 20 100 3 		\
		"-g" "Debugging symbols" 	on		\
		"-Wall" "All warnings"		on		\
		"-Wextra" "Extra warnings"	on	2>/tmp/diag_out
	ret=$?
	eval "$1='$(cat /tmp/diag_out)'"
	rm /tmp/diag_out
	return $ret
}

#First argument must be a holder for the resulted IPATH string
function get_ipath(){
	if [ $# -eq 0 ]
	then
		return -1
	fi

	IPATH=""
	DIAG_EXIT=0
	while [ $DIAG_EXIT -eq 0 ]
	do
		dialog 	--backtitle "C IDE"					\
				--title "Include paths"				\
				--inputbox "Do you want to add \
a path to the -I paths?\n" 20 100 2> /tmp/diag_out
		DIAG_EXIT=$?
		OUT=$(cat /tmp/diag_out)
		if [ "$OUT" != "" ]
		then
			IPATH+="-I$OUT "
		else
			((DIAG_EXIT=1))
		fi
	done
	eval "$1='$IPATH'"
	rm /tmp/diag_out
}

#First argument must be a holder for the resulted LPATH string
function get_lpath(){
	if [ $# -eq 0 ]
	then
		return -1
	fi

	LPATH=""
	DIAG_EXIT=0
	while [ $DIAG_EXIT -eq 0 ]
	do
		dialog 	--backtitle "C IDE"					\
				--title "Link paths"				\
				--inputbox "Do you want to add \
a path to the -L paths?\n" 20 100 2> /tmp/diag_out
		DIAG_EXIT=$?
		OUT=$(cat /tmp/diag_out)
		if [ "$OUT" != "" ]
		then
			LPATH+="-L$OUT "
		else
			((DIAG_EXIT=1))
		fi
	done
	if [ "$LPATH" != "" ]
	then
		eval "$i='$LPATH'"
	fi
	rm /tmp/diag_out
}

#First argument must be a holder for the resulted LIBS string
function get_libs(){
	if [ $# -eq 0 ]
	then
		return -1
	fi

	LIBS=""
	DIAG_EXIT=0
	while [ $DIAG_EXIT -eq 0 ]
	do
		dialog 	--backtitle "C IDE"					\
				--title "Libraries"					\
				--inputbox "Do you want to add \
	a library to the project?\n\
	Hit cancel when you're done" 20 100\
				2> /tmp/diag_out
		DIAG_EXIT=$?
		OUT=$(cat /tmp/diag_out)
		if [ "$OUT" != "" ]
		then
			LIBS+="$OUT "
		else
			((DIAG_EXIT=1))
		fi
	done
	eval "$1='$LIBS'"
	rm /tmp/diag_out
}