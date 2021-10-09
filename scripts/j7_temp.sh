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
        out_str=$($K3CONF1 read 0x04504104 |  sed -e '/|----*/d' -e '/VERSION/d'  -e '/Value at*/d')
        echo "$out_str"
}

oc_func

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
	echo "test ----"
}

dump_dss_clk_regs() {
	dump_reg "0x04580B00" "DPHY_RX_VBUS2APB_WRAP_VBUSP_K3_DPHY_RX";
	dump_reg "0x04504110" "CSI_RX_IF_VBUS2APB0"
}

dump_dss_clk_regs
