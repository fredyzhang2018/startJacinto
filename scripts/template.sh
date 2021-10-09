# case 
	case $PORT_NUM in
		"1")
			
		;;
		"2")
			reg_temp=0x00104048
		;;
		"3")
			echo "3"
		;;
		"4")
			echo "4"
		;;
		"5")
			echo "5"
		;;
		"6")
			echo "6"
		;;
		"7")
			echo "7"
		;;
		"8")
			echo "8"
		;;
		*)
			echo "Input is not correct"
		;;
	esac
	
# register	
check_field() {
	val=$1
	shift=$2
	mask=$3
	fld=`printf "0x%08x" $(( $val >> $shift ))`
	fld=$(( $fld & 0x$mask ))
	if [ $fld = "0" ]; then
		echo $4
	elif [ $fld = "1" ]; then
		echo $5
	elif [ $fld = "2" ]; then
		echo $6
	elif [ $fld = "3" ]; then
		echo $7
	elif [ $fld = "4" ]; then
		echo $8
	elif [ $fld = "5" ]; then
		echo $9
	elif [ $fld = "6" ]; then
		echo $10
	elif [ $fld = "7" ]; then
		echo $11
	else
		echo "Unknown"
	fi
}
get_field() {
	start=$1
	offset=$2
	shift=$3
	mask=$4
	addr=`printf "0x%08x" $(( $start + $offset ))`
	val=0x$($K3CONF1 read "$addr" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g')
	fld=`printf "0x%08x" $(( $val >> $shift ))`
	fld=`printf "%d" $(( $fld & $mask ))`
	echo $fld
}
