#!/bin/bash
# Author:- Fredy Zhang
# Modified for J7 960 configure.
cwd=`dirname $0`
. $cwd/common.sh


configure_pattern () {
	i2cset -f -y 9 0x3d 0x32 0x01                         
	i2cset -f -y 9 0x3d 0x33 0x02             
	i2cset -f -y 9 0x3d 0xB0 0x02     
	i2cset -f -y 9 0x3d 0xB1 0x01       
	i2cset -f -y 9 0x3d 0xB2 0x01      
	i2cset -f -y 9 0x3d 0xB2 0x34     
	i2cset -f -y 9 0x3d 0xB2 0x1E    
	i2cset -f -y 9 0x3d 0xB2 0x05     
	i2cset -f -y 9 0x3d 0xB2 0x00          
	i2cset -f -y 9 0x3d 0xB2 0x00     
	i2cset -f -y 9 0x3d 0xB2 0xA0      
	i2cset -f -y 9 0x3d 0xB2 0x01     
	i2cset -f -y 9 0x3d 0xB2 0xE0   
	i2cset -f -y 9 0x3d 0xB2 0x02    
	i2cset -f -y 9 0x3d 0xB2 0x0D   
	i2cset -f -y 9 0x3d 0xB2 0x18  
	i2cset -f -y 9 0x3d 0xB2 0xCD 
	i2cset -f -y 9 0x3d 0xB2 0x21   
	i2cset -f -y 9 0x3d 0xB2 0x0A      
	i2cset -f -y 9 0x3d 0xB2 0xAA    
	i2cset -f -y 9 0x3d 0xB2 0x33    
	i2cset -f -y 9 0x3d 0xB2 0xF0
	i2cset -f -y 9 0x3d 0xB2 0x7F  
	i2cset -f -y 9 0x3d 0xB2 0x55  
	i2cset -f -y 9 0x3d 0xB2 0xCC
	i2cset -f -y 9 0x3d 0xB2 0x0F
	i2cset -f -y 9 0x3d 0xB2 0x80
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	i2cset -f -y 9 0x3d 0xB2 0x00
	check_status
}

start_ub960(){
	i2cset -f -y  9 0x3d 0x33 0x23
	check_status
	i2cget -f -y 9 0x3d 0x33
}

stop_ub960(){
	i2cset -f -y  9 0x3d 0x33 0x02
	check_status
	i2cget -f -y 9 0x3d 0x33
}

while ((1));do
	echo "please input the selection: "
	echo "	1. statt ub960 "
	echo "	2. stop  ub960"
	echo "	3. configure ub960 pattern"
	echo "	0 exit"
	read -p "[ please input your selection: ] "  selection
	case $selection in
		"1")
			start_ub960
			echo "start ub960!"
		;;
		"2")
			stop_ub960
			echo "stop  ub960 done!"
        ;;
        "3")
			configure_pattern
			echo " configure done !"
        ;;
        "0")
			echo " exit the program "
			exit 0
        ;;
		*)	
			echo "Your choose is error!"
		;;
	esac
done

