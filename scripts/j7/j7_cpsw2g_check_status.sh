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
        echo "    CPSW2G status check "
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
# port mode selection
CTRLMMR_MCU_ENET_CTRL()
{
	base_addr=0x40f04040
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CTRLMMR_ENET $PORT_NUM CTRL ($reg_temp) = $reg_val  "
	echo "	PORT_MODE_SEL          : "`check_field $reg_val 0  3 "0h GMII/MII (Not supported)" "1h RMII" "2h RGMII" "3h SGMII" "4h QSGMII" "5h XFI(Not Support)" "6h QSGMII_SUB"`
	echo "	RGMII_ID_MODE          : "`check_field $reg_val 4  1 "0h Internal Transmit Desaly "   "Reserved"`
}
# CPSW statistics Port Enable Register
CPSW_MDIO_CONTROL_REG()
{
	base_addr=0x46000f04
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_MDIO_CONTROL_REG ($reg_temp) = $reg_val  "
	echo "	CLKDIV               : "`get_field $reg_val 0x00  0 0xf`
	echo "	INT_TEST_ENABLE      : "`check_field $reg_val 17  1 "0h not enabled" "1h enabled"`
	echo "	FAULT_DETECT_ENABLE  : "`check_field $reg_val 18  1 "0h not enabled" "1h enabled"`
	echo "	FAULT                : "`check_field $reg_val 19  1 "0h not enabled" "1h enabled"`
	echo "	PREAMBLE             : "`check_field $reg_val 20  1 "0h CLAUSE 45" "1h CLAUSE 22"`
	echo "	ENABLE               : "`check_field $reg_val 30  1 "0h disalbe MDIO contorl" "1h enable MDIO control"`
	echo "	IDLE                 : "`check_field $reg_val 30  1 "0h _____" "1h idle state"`
}

# MDIO Alive Reg check 
CPSW_MDIO_ALIVE_REG()
{
	base_addr=0x46000f08
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_MDIO_ALIVE_REG ($reg_temp) = $reg_val  "
	for k in $( seq 0 31 )
	do
		if [ `check_field $reg_val $k  1 "No" "Yes"` == "Yes" ]; then
			echo "	bit $k  : "`check_field $reg_val $k  1 "No" "Yes"`
		fi
	done
}

# MDIO Alive Reg check 
CPSW_MDIO_LINK_REG()
{
	base_addr=0x46000f0c
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_MDIO_LINK_REG ($reg_temp) = $reg_val  "
	for k in $( seq 0 31 )
	do
		if [ `check_field $reg_val $k  1 "No" "Yes"` == "Yes" ]; then
			echo "	bit $k  : "`check_field $reg_val $k  1 "No" "Yes"`
		fi
	done
}

CPSW_SS_RGMII_STATUS_REG()
{
	base_addr=0x46000018
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW SS RGMII STATUS ($reg_temp) = $reg_val  "
	echo "	FULLDUPLEX           : "`check_field $reg_val 0  1 "0h Half duplex" "1h Full duplex"`
	echo "	SPEED                : "`check_field $reg_val 1  2 "0h 10Mbps" "1h 100Mbps" "1000Mbps" "Reserved"`
	echo "	LINK                 : "`check_field $reg_val 3  1 "0h Links is down" "1h Link is up"`
}

check_CPSW2G_status() {
	# configure K3conf
	oc_func
	# CPSW MDIO Alive check 
	CPSW_MDIO_ALIVE_REG
	# CPSW MDIO Link check 
	#CPSW_MDIO_LINK_REG
	# CPSW MDIO CONTROL REG
	#CPSW_MDIO_CONTROL_REG
	# check CPSW9G port config status
	#CTRLMMR_MCU_ENET_CTRL
	# check the port RGMII status
	CPSW_SS_RGMII_STATUS_REG
	
}


# check the CPSW2G status
check_CPSW2G_status
#
#CPSW_MDIO_ALIVE_REG







