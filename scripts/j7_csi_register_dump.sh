#!/bin/bash
# Author:- Fredy Zhang
# Modified by Venkateswara Rao Mandela for HDMI PLL support
# and ADB support

#This script is used for debugging issues with CSI.
#It dumps the CSI registers and 

# Modify this string to --force <platname> if platform detection fails
FORCE_PLAT=""

# Set this variable to 1 when running against an Android Build
# The android shell has limited functionality. So this script runs
# omapconf via adb and parses the output on the host.

# Define a function that wraps omapconf calls and removes the usual warning
# messages
oc_func() {
        K3CONF1="k3conf"
        echo $K3CONF1
}

# Dump a register value given the address and the register name
# also exports a variable of the given name with the read value
dump_reg() {
	reg=$1
	regname=$2
	local __outname=$2
	val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	echo "$regname ($reg) = $val"
	echo
	eval "$__outname"="'$val'"
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
	else
		echo "Unknown"
	fi
}
dump_CSI_regs() {
	echo "dump registers"
	dump_reg "0x04580B00" "DPHY_RX_VBUS2APB_WRAP_VBUSP_K3_DPHY_RX";
	dump_reg "0x04504100" "CSI_RX_IF_VBUS2APB_STREAM0_CTRL"
#	dump_reg "0x04504040" "CSI_RX_IF_VBUS2APB_DPHY_LANE_CONTROL"
	echo "-------------------------------> done"
}


check_CSI_status() {
	# configure K3conf
	oc_func
	# dump CSI regs
	dump_CSI_regs
	# check the status
	reg=0x04504100
	val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	echo "CSI_RX_IF_VBUS2APB_STREAM0_CTRL Instances ($reg) = $val"
	echo "	csi2rx status : "	`check_field $val 0 3 "NULL" "start" "stop" "NULL" "abort" "NULL"`
	echo "	csi2rx SOF_RST: "	`check_field $val 4 1 "Enabled" "Disabled"`
	echo
	reg=0x04504020
	val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	echo "CSI_RX_IF_VBUS2APB_INFO_IRQS ($reg) = $val  "
	echo "	SP_RCVD_IRQ            : "`check_field $val 0  1 "Short Packet received by the protocol module ---> No" "Short Packet received by the protocol module ---> YES"`
	echo "	LP_RCVD_IRQ            : "`check_field $val 1  1 "Long Packet received by the protocol module  ---> No"   "Long Packet received by the protocol module  ---> Yes"`
	echo "	SLEEP_IRQ              : "`check_field $val 2  1 "Sleep interrupt --> No" "Sleep interrupt --> Yes"`
	echo "	WAKEUP_IRQ             : "`check_field $val 3  1 "Wake-up interrupt --> No" "Wake-up interrupt --> Yes"`
	echo "	ECC_SPARES_NONZERO_IRQ : "`check_field $val 4  1 " No" "Yes"`
	echo "	DESKEW_ENTRY_IRQ       : "`check_field $val 5  1 "Either clock or any datalane has entered deskew --> No" "Either clock or any datalane has entered deskew --> Yes"`
	echo "	SP_GENERIC_RCVD_IRQ    : "`check_field $val 6  1 "A generic short packet has been received --> No " "A generic short packet has been received --> YES"`
	echo "	STREAM0_STOP_IRQ       : "`check_field $val 7  1 "Stream x Stop process complete  --> No" "Stream x Stop process complete  --> Yes"`
	echo "	STREAM0_ABORT_IRQ      : "`check_field $val 8  1 "Stream x Abort process complete --> No" "Stream x Abort process complete --> Yes"`
	echo "	STREAM1_STOP_IRQ       : "`check_field $val 9  1 "Stream x Stop process complete  --> No" "Stream x Stop process complete  --> Yes"`
	echo "	STREAM1_ABORT_IRQ      : "`check_field $val 10 1 "Stream x Abort process complete --> No" "Stream x Abort process complete --> Yes"`
	echo "	STREAM2_STOP_IRQ       : "`check_field $val 11 1 "Stream x Stop process complete  --> No" "Stream x Stop process complete  --> Yes"`
	echo "	STREAM2_ABORT_IRQ      : "`check_field $val 12 1 "Stream x Abort process complete --> No" "Stream x Abort process complete --> Yes"`
	echo "	STREAM3_STOP_IRQ       : "`check_field $val 13 1 "Stream x Stop process complete  --> No" "Stream x Stop process complete  --> Yes"`
	echo "	STREAM3_ABORT_IRQ      : "`check_field $val 14 1 "Stream x Abort process complete --> No" "Stream x Abort process complete --> Yes"`
	echo
	#~ reg=0x04504040
	#~ val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	#~ echo "CSI_RX_IF_VBUS2APB_DPHY_LANE_CONTROL($reg) = $val  "
	#~ echo "	DL0_ENABLE	            : "`check_field $val 0  1 "No" "Yes"`
	#~ echo "	DL1_ENABLE              : "`check_field $val 1  1 "No" "Yes"`
	#~ echo "	DL2_ENABLE              : "`check_field $val 2  1 "No" "Yes"`
	#~ echo "	DL3_ENABLE              : "`check_field $val 3  1 "No" "Yes"`
	#~ echo "	CL_ENABLE               : "`check_field $val 4  1 "No" "Yes"`
	#~ echo "	DL0_RESET               : "`check_field $val 12 1 "No" "Yes"`
	#~ echo "	DL1_RESET               : "`check_field $val 13 1 "No" "Yes"`
	#~ echo "	DL2_RESET               : "`check_field $val 14 1 "No" "Yes"`
	#~ echo "	DL3_RESET               : "`check_field $val 15 1 "No" "Yes"`
	#~ echo "	CL_RESET                : "`check_field $val 16 1 "No" "Yes"`
	#~ echo
	reg=0x04504000
	val=0x$($K3CONF1 read "$reg" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g' )
	echo "CSI_RX_IF_VBUS2APB_INFO_IRQS ($reg) = $val  "
	echo "	bit 0  : "`check_field $val 0  1 "No" "Yes"`
	echo "	bit 1  : "`check_field $val 1  1 "No" "Yes"`
	echo "	bit 2  : "`check_field $val 2  1 "No" "Yes"`
	echo "	bit 3  : "`check_field $val 3  1 "No" "Yes"`
	echo "	bit 4  : "`check_field $val 4  1 "No" "Yes"`
	echo "	bit 5  : "`check_field $val 5  1 "No" "Yes"`
	echo "	bit 6  : "`check_field $val 6  1 "No" "Yes"`
	echo "	bit 7  : "`check_field $val 7  1 "No" "Yes"`
	echo "	bit 8  : "`check_field $val 8  1 "No" "Yes"`
	echo "	bit 9  : "`check_field $val 9  1 "No" "Yes"`
	echo "	bit 10 : "`check_field $val 10 1 "No" "Yes"`
	echo "	bit 11 : "`check_field $val 11 1 "No" "Yes"`
	echo "	bit 12 : "`check_field $val 12 1 "No" "Yes"`
	echo "	bit 13 : "`check_field $val 13 1 "No" "Yes"`
	echo "	bit 14 : "`check_field $val 14 1 "No" "Yes"`
	echo "	bit 15 : "`check_field $val 15 1 "No" "Yes"`
	echo "	bit 16 : "`check_field $val 16 1 "No" "Yes"`
	echo "	bit 17 : "`check_field $val 17 1 "No" "Yes"`
	echo "	bit 18 : "`check_field $val 18 1 "No" "Yes"`
	echo "	bit 19 : "`check_field $val 19 1 "No" "Yes"`
	echo "	bit 20 : "`check_field $val 20 1 "No" "Yes"`
	echo "	bit 21 : "`check_field $val 21 1 "No" "Yes"`
	echo "	bit 22 : "`check_field $val 22 1 "No" "Yes"`
	echo "	bit 23 : "`check_field $val 23 1 "No" "Yes"`
	echo "	bit 24 : "`check_field $val 24 1 "No" "Yes"`
	echo "	bit 25 : "`check_field $val 25 1 "No" "Yes"`
	echo "	bit 26 : "`check_field $val 26 1 "No" "Yes"`
	echo "	bit 27 : "`check_field $val 27 1 "No" "Yes"`
	echo "	bit 28 : "`check_field $val 28 1 "No" "Yes"`
	echo "	bit 29 : "`check_field $val 29 1 "No" "Yes"`
	echo "	bit 30 : "`check_field $val 30 1 "No" "Yes"`
	echo "	bit 31 : "`check_field $val 31 1 "No" "Yes"`
}
check_CSI_status
#~ oc_funcIUYTREWWQQ
#~ dump_dss_clk_regs
#~ echo "0x04504000"
#~ regm=`get_field 0x04504000 0x00  0 0xc`

#~ printf "0x%08x" $regm \n
#~ echo $regm
