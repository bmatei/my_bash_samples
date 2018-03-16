
function m_add(){
	eval $3=$(($1 + $2))
}

function m_sub(){
	eval $3=$(($1 - $2))
}

function m_mul(){
	eval $3=$(($1 * $2))
}

function m_div(){
	if [ $2 -eq 0 ]
	then
		return 1
	fi
	m_div_rez=$(echo "scale = 2;$1/$2" | bc)
	eval $3=$m_div_rez
}

function m_mod(){
	eval $3=$(($1 % $2))
}