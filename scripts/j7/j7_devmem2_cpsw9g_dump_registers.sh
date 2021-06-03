#!/bin/bash
# Author:- Fredy Zhang
# This scripts : check the cpsw9G status

# Modify this string to --force <platname> if platform detection fails
FORCE_PLAT="J7 TDA4VM"

# Set this variable to 1 when running against an Android Build
# The android shell has limited functionality. So this script runs
# omapconf via adb and parses the output on the host.

# Define a function that wraps omapconf calls and removes the usual warning
# messages
oc_func() {
        K3CONF1="k3conf"
        echo "    Platform: $FORCE_PLAT  "
        echo "    Command:  $K3CONF1  "
        echo "    Command:  $K3CONF1  "
}

# Dump a register value given the address and the register name
# also exports a variable of the given name with the read value
# Examples： 
#	dump_reg "0x04504040" "CSI_RX_IF_VBUS2APB_DPHY_LANE_CONTROL"
dump_reg() {
	reg=$1
	regname=$2
	local __outname=$2
	devmem_read $reg
	echo "$regname ($reg) = $reg_val"
	echo
	eval "$__outname"="'$val'"
}

# Dump a register value given the address and the register name
# also exports a variable of the given name with the read value
# Examples： 
#	dump_reg "0x04504040" 
dump_reg_value() {
	reg=$1
	regname=$2
	local __outname=$1
	devmem_read $reg
}
# Examples： 
#	regm=`get_field 0x04504000 0x00  0 0xc`
get_field() {
	start=$1
	offset=$2
	shift=$3
	mask=$4
	addr=`printf "0x%08x" $(( $start + $offset ))`
	devmem_read $addr
	fld=`printf "0x%08x" $(( $reg_val >> $shift ))`
	fld=`printf "%d" $(( $fld & $mask ))`
	echo $fld
}

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

# Read register
k3conf_read_reg()
{
	#echo $0 $1 
	addr=$1
	reg_val=0x$($K3CONF1 read "$addr" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g')
}


devmem_read()
{
	#echo $0 $1 
	addr=$1
	reg_val=0x$(devmem2 $addr | sed -n '3,3p' | cut -f 2 -d ':' | sed 's/ 0x//g' )
}


# MDIO Alive Reg check 
CPSW9g_dump_CPSW0_SGMII_registers()
{
	
	echo "dump the spsw0 SGMII Registers : 0x0c000100 ~ 0x0c00074c"
	for k in $( seq 0x0c000100 0x0c00074c )
	do
		fld=`printf "0x%08x" $k`
		dump_reg_value $fld 
		echo "$fld = $reg_val"
	done
}


CPSW9g_dump_CTRL_MMR0_Registers()
{
	
	echo "dump the spsw0 CTRL MMR0 Registers : 0x00104044 ~ 0x00104062"
	for k in $( seq 0x00104044 0x00104062 )
	do
		fld=`printf "0x%08x" $k`
		dump_reg_value $fld 
		echo "$fld = $reg_val"
	done
}


dump_CPSW9G_registers() {
	# configure K3conf
	oc_func
	# CPSW MDIO Alive check 
	CPSW9g_dump_CPSW0_SGMII_registers
	# Dump CTRL_MMR0
	CPSW9g_dump_CTRL_MMR0_Registers
}


# run below registers
dump_CPSW9G_registers







