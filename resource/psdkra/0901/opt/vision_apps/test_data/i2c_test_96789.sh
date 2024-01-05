#!/bin/sh
#############################################################################################
# This script is using for I2C serdes debugging                                          #
#      
# @Author : Fredy Zhang                                                                     #
# @email  ：fredy-zhang@ti.com 																#				
# @date   ：2023-12-23                                                                      # 
##############################################################################################
# Modify this string to --force <platname> if platform detection fails
FORCE_PLAT="J721S2"
# Set this variable to 1 when running against an Android Build
# The android shell has limited functionality. So this script runs
# omapconf via adb and parses the output on the host.

# Define a function that wraps omapconf calls and removes the usual warning
# messages
oc_func1() {
        echo "    i2c testing..."
        COMMAND="i2ctransfer"
        echo "    Platform: $FORCE_PLAT  "
        echo "    Command:  $COMMAND  "
}
oc_func() {
        echo "    DSS register dumping..."
        K3CONF1="k3conf"
        echo "    Platform: $FORCE_PLAT  "
        echo "    Command:  $K3CONF1  "
        echo "    Author: Fredy Zhang "
}
# read addr value
# $1 add 
# read a register value given the address 
# Examples： 
#	k3conf_read_reg "0x04504040" 
k3conf_read_reg()
{
#	echo $0 $1 
	addr=$1
        # k3conf read $addr
	reg_val=0x$(k3conf read "$addr" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g')
	echo "$addr = $reg_val"
}
# read addr value
# $1 add 
read_value()
{
    instance=$1
    addr=$2
    let "value1=$3>>8"
    value2=`printf "0x%08x" $(( $3 & 0xFF ))`
    value3=$4
    #echo "$COMMAND -y -f $instance w2@$addr $value1 $value2 $value3" 
    ret_val=$($COMMAND -y -f $instance w2@$addr $value1 $value2 $value3 )
    echo "$3 = $ret_val"
}

write_value()                                                             
{                                                                        
    instance=$1                                                          
    addr=$2                                                                                             
    let "value1=$3>>8"                                                                                  
    value2=`printf "0x%08x" $(( $3 & 0xFF ))`                                                           
    value3=$4                                                                                           
    #echo "$COMMAND -y -f $instance w3@$addr $value1 $value2 $value3"                                    
    $COMMAND -y -f $instance w3@$addr $value1 $value2 $value3                                                                                                         
} 

check_status()
{
	echo "clock check: "
	read_value 1 0x42 0x102 r1
	read_value 1 0x42 0x10a r1
	echo "--- error check:"
	read_value 1 0x42 0x339 r1
	read_value 1 0x42 0x33a r1
	read_value 1 0x42 0x33b r1
	read_value 1 0x42 0x3ac r1
	read_value 1 0x42 0x3a0 r1
	echo "--- HS VS DE :"
	read_value 1 0x42 0x55d r1
	read_value 1 0x42 0x55e r1
	read_value 1 0x42 0x55f r1
	read_value 1 0x42 0x56a r1	
	echo "--- lane 2 lane seting"
	read_value 1 0x42 0x331 r1
	echo "--- checking reg"
	read_value 1 0x42 0x302 r1
	read_value 1 0x42 0x002 r1
	read_value 1 0x42 0x053 r1
	read_value 1 0x42 0x057 r1
	read_value 1 0x42 0x332 r1
	read_value 1 0x42 0x333 r1
	read_value 1 0x42 0x004 r1
	read_value 1 0x42 0x308 r1
	read_value 1 0x42 0x311 r1
	read_value 1 0x42 0x331 r1
	read_value 1 0x42 0x330 r1
	read_value 1 0x42 0x389 r1
	read_value 1 0x42 0x388 r1
	read_value 1 0x42 0x1F0 r1
	read_value 1 0x42 0x1F1 r1
	echo "temp"
#	write_value 1 0x42 0x1F0 0x58
#	write_value 1 0x42 0x1F1 0x59	
#	read_value 1 0x42 0x1F0 r1
#	read_value 1 0x42 0x1F1 r1
	
}

soc_status_check()
{

        echo "....TDA4 soc check ... "
	echo " BURST_MODE [18]"                                     
	echo " SYNC_PULSE_ACTIVV [19]"
	echo " SYNC_PULSE_HORIZONTAL [20]"
	echo " REG_BLKLINE_MODE [21-22] :  REG_BLKLINE_MODE : behavior during blanking time [1x: LP, 01: blanking packet - 00: NULL packet] "
	k3conf_read_reg 0x049000b0                   
	echo "continued clock bit4 1"                                                                        
	k3conf_read_reg 0x04900008                                              
	echo "CLKLANE_STATE[0:1]: state of the clock lane [00: start / 01: idle / 10: HS / 11: ULPM]"
	k3conf_read_reg 0x0490002c
        echo "DSS_DSI_direct_cmd_rd_sts_ctl"
	k3conf_read_reg 0x0490003c 

        echo "EOT: 0x04900004"
	k3conf_read_reg 0x04900004 
}

write_i2c()
{

	write_value 1 0x42 0x331 0x1 

}


# start from here 
oc_func
oc_func1
#write_i2c
check_status
soc_status_check
