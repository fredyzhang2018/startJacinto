#!/bin/bash
# Author:- Fredy Zhang
# This scripts : check the boot setting and boot status

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
#	regm=`get_field 0x04504000 0x00  0 0xc`
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
	#echo $0 $1 
	addr=$1
	reg_val=0x$($K3CONF1 read "$addr" | sed -n '9,9p' | sed  's/Value at addr //g' | cut -f 2 -d '=' | sed 's/ 0x//g')
}
CTRLMMR_MAIN_DEVSTAT()
{
	# indicates SoC bootstrap selection. 
	# used for 0-7
	echo "The register reflects the BOOTMODE pin values sampled at internal POR release"
	base_addr=0x00104040
	reg_temp=`printf "0x%08x" $(($PORT_NUM*4+$base_addr))`
	#k3conf_read_reg $reg_temp
	reg_val=0x00000000
	echo "CTRLMMR_ENET $PORT_NUM CTRL ($reg_temp) = $reg_val  "
	echo "	PORT_MODE_SEL          : "`check_field $reg_val 0  7 "0h GMII/MII (Not supported)" "1h RMII" "2h RGMII" "3h SGMII" "4h QSGMII" "5h XFI(Not Support)" "6h QSGMII_SUB"`
	echo "	RGMII_ID_MODE          : "`check_field $reg_val 4  1 "0h Internal Transmit Desaly "   "Reserved"`
}

CTRLMMR_WKUP_DEVSTAT()
{
	# indicates MCU bootstrap selection. 
	# address 
	echo "The register reflects the MCU_BOOTMODE pin values sampled at internal POR release"
	base_addr=0x43000030
	reg_temp=`printf "0x%08x" $(($base_addr))`
	#k3conf_read_reg $reg_temp
	reg_val=0x00000001
	echo "CTRLMMR_WKUP_DEVSTAT ($reg_temp) = $reg_val  "
	echo "	WKUP_HFOSC0 frequency selection          : "`check_field $reg_val 0  7  "0h 19.2Mhz" "1h 20Mhz" "2h 24Mhz" "3h 25Mhz" "4h 26Mhz" "5h 27Mhz" "6h Reserved for device test" "7h No PLL configuration"` 
	echo "	MCU primary BOOTMODE                     : "`check_field $reg_val 3  7  "0h OSPI --> UART"   "1h QSPI --> UART" "2h SPI --> UART" "3h Ethernet RGMII --> I2C" "4h Ethernet RMII --> I2C " "5h I2C --> UART "`
	echo "	MCU Only Configuration                   : "`check_field $reg_val 6  1  "0h No "   "1h Yes"`
	echo "	POST Selection: Bits 9:8 "
	echo "	Power-on Self Test Mode :                : "`check_field $reg_val 8  3  "0h DMSC LBIST followed by MCU LIST followed by PBIST "   "1h DMSC LBIST and MCU LBIST in parallel followed by PBIST " "3h Reserved" "POST by pass"`

}

check_boot_status() {
	# configure K3conf
	oc_func
	# check MCU_BOOTPIN
	CTRLMMR_WKUP_DEVSTAT
}


# check the CPSW9G status
check_boot_status
#
#CPSW_MDIO_ALIVE_REG
#CTRLMMR_ENET_x_CTRL






