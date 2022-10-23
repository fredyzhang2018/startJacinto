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
	val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	echo "$regname ($reg) = $val"
	echo
	eval "$__outname"="'$val'"
}
# Examples： 
#	get_field  "0x04504040" "CSI_RX_IF_VBUS2APB_DPHY_LANE_CONTROL"
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
	reg = $1
	val = $2
	$val=0x$($K3CONF1 read "$reg_temp" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
}
CTRLMMR_ENET_x_CTRL()
{
	base_addr=0x00104040
	reg_temp=`printf "0x%08x" $(($PORT_NUM*4+$base_addr))`
	k3conf_read_reg $reg_temp $val
	echo "CTRLMMR_ENET $PORT_NUM CTRL ($reg_temp) = $val  "
	echo "	PORT_MODE_SEL          : "`check_field $val 0  3 "0h GMII/MII (Not supported)" "1h RMII" "2h RGMII" "3h SGMII" "4h QSGMII" "5h XFI(Not Support)" "6h QSGMII_SUB"`
	echo "	RGMII_ID_MODE          : "`check_field $val 4  1 "0h Internal Transmit Desaly "   "Reserved"`
}
s
check_CPSW9G_status() {
	# configure K3conf
	oc_func
	# check CPSW9G port config status
	read -p "please input your port:  "  PORT_NUM
	CTRLMMR_ENET_x_CTRL
}

check_CPSW9G_status

#~ check_CSI_status
#~ oc_funcIUYTREWWQQ
#~ dump_dss_clk_regs
#~ echo "0x04504000"
#~ regm=`get_field 0x04504000 0x00  0 0xc`

#~ printf "0x%08x" $regm \n
#~ echo $regm
