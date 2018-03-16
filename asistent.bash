#!/bin/bash

#Check command line
if [ $# -ne 1 ]
then
	echo "Usage: $0 <prj_name>"
	exit 1
fi

#Get project type (C/C++)
dialog 	--backtitle "Project Creator 3000"		\
		--title "Project type"					\
		--radiolist 							\
	"What kind of project do you wanna create?"	\
		20 80 2 "c" "C Project" on "cpp" 		\
		"C++ Project" off	2> /tmp/status

EXT=$(cat /tmp/status)
OB=""
if [ "$EXT" = "cpp" ]
then
	OB="obj"
else
	OB="o"
fi

#Get number of aditional C/C++ files
dialog 	--backtitle "Project Creator 3000"				\
		--title "Project size" --inputbox				\
		"How many extra files will your project have?"	\
		20 80 2> /tmp/status

PRJ_NUM="$(cat /tmp/status | sed -e 's/^\([0-9]*\).*/\1/')"

#Get aditional source files names
SRC=""
INC=""
OBJ=""
for i in $(seq 1 $PRJ_NUM)
do
	dialog 	--backtitle "Project Creator 3000"		\
			--title "Project files" --inputbox		\
			"What's the name of the new component?"	\
			20 80 2> /tmp/status
	TMP=$(cat /tmp/status)
	SRC+="$TMP.$EXT "
	INC+="$TMP.h "
	OBJ+="obj/$TMP.$OB "
done

#Go $HOME
cd ~

#Make the project directory structure
mkdir $1
cd $1
mkdir bin obj src inc
touch $1.$EXT $1.h build.sh
cd src
touch $SRC
cd ../inc
touch $INC
cd ..

#Build the "build.sh" file
SRCAR=( $SRC )
OBJAR=( $OBJ )
echo -e "#!/bin/bash" > build.sh
for i in $(seq 0 $(($PRJ_NUM-1)) )
do
	echo "gcc -Iinc -c -o \"${OBJAR[$i]}\" \"src/${SRCAR[$i]}\"" >> build.sh
done
echo "gcc -Iinc -o bin/$1 \"$1.$EXT\" $OBJ" >> build.sh
chmod +x build.sh