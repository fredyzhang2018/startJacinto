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
CTRLMMR_ENET_x_CTRL()
{
	# PORT_NUM should be 1-8
	# PORT_NUM 1 address : 0x00104044
	base_addr=0x00104040
	reg_temp=`printf "0x%08x" $(($PORT_NUM*4+$base_addr))`
	k3conf_read_reg $reg_temp
	echo "CTRLMMR_ENET $PORT_NUM CTRL ($reg_temp) = $reg_val  "
	echo "	PORT_MODE_SEL          : "`check_field $reg_val 0  7 "0h GMII/MII (Not supported)" "1h RMII" "2h RGMII" "3h SGMII" "4h QSGMII" "5h XFI(Not Support)" "6h QSGMII_SUB"`
	echo "	RGMII_ID_MODE          : "`check_field $reg_val 4  1 "0h Internal Transmit Desaly "   "Reserved"`
}
# CPSW statistics Port Enable Register
CPSW_STAT_PORT_EN_REG()
{
	base_addr=0x0c020014
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_STAT_PORT_EN_REG ($reg_temp) = $reg_val  "
	echo "	P0_STAT_EN           : "`check_field $reg_val 0  1 "0h PORT0 statistics are not enabled" "1h port 0 statistics are enabled"`
	echo "	P1_STAT_EN           : "`check_field $reg_val 1  1 "0h PORT1 statistics are not enabled" "1h port 1 statistics are enabled"`
	echo "	P2_STAT_EN           : "`check_field $reg_val 2  1 "0h PORT2 statistics are not enabled" "1h port 2 statistics are enabled"`
	echo "	P3_STAT_EN           : "`check_field $reg_val 3  1 "0h PORT3 statistics are not enabled" "1h port 3 statistics are enabled"`
	echo "	P4_STAT_EN           : "`check_field $reg_val 4  1 "0h PORT4 statistics are not enabled" "1h port 4 statistics are enabled"`
	echo "	P5_STAT_EN           : "`check_field $reg_val 5  1 "0h PORT5 statistics are not enabled" "1h port 5 statistics are enabled"`
	echo "	P6_STAT_EN           : "`check_field $reg_val 6  1 "0h PORT6 statistics are not enabled" "1h port 6 statistics are enabled"`
	echo "	P7_STAT_EN           : "`check_field $reg_val 7  1 "0h PORT7 statistics are not enabled" "1h port 7 statistics are enabled"`
}

# MDIO Alive Reg check 
CPSW_MDIO_ALIVE_REG()
{
	base_addr=0x0C000F08
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "MDIO_ALIVE_REG ($reg_temp) = $reg_val  "
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
	base_addr=0x0C000F0C
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "MDIO_LINK_REG ($reg_temp) = $reg_val  "
	for k in $( seq 0 31 )
	do
		if [ `check_field $reg_val $k  1 "No" "Yes"` == "Yes" ]; then
			echo "	bit $k  : "`check_field $reg_val $k  1 "No" "Yes"`
		fi
	done
}

CPSW_SS_RGMIIx_STATUS_REG()
{
	base_addr=0x0C00002C
	# PORT_NUM should be 1-8
	# PORT 1 address is 0x0c00002c
	reg_temp=`printf "0x%08x" $(($PORT_NUM*4+$base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW SS RGMII $PORT_NUM STATUS ($reg_temp) = $reg_val  "
	echo "	FULLDUPLEX           : "`check_field $reg_val 0  1 "0h Half duplex" "1h Full duplex"`
	echo "	SPEED                : "`check_field $reg_val 1  3 "0h 10Mbps" "1h 100Mbps" "1000Mbps" "Reserved"`
	echo "	LINK                 : "`check_field $reg_val 3  1 "0h Links is down" "1h Link is up"`
}

CPSW_SS_SGMII_CONTROL_REG_j()
{
	base_addr=0x0C000010
	# PORT_NUM should be 1-8
	# THe SGMII 0 address is 0c000110h+j*100h
	reg_temp=`printf "0x%08x" $(($PORT_NUM*0x100+$base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_SS_SGMII_CONTROL_REG_j ($reg_temp) = $reg_val  "
	echo "	TEST_PATTERN_EN      : "`check_field $reg_val 6  1 "0h operation" "1h Forced K28.5 on TX_ENC for test purposes"`
	echo "	MASTER               : "`check_field $reg_val 5  1 "0h Slave Mode" "1h Master Mode"`
	echo "	LOOPBACK             : "`check_field $reg_val 4  1 "0h Not in internal loopback mode" "1h internal loopback mode"`
	echo "	MR_NP_LOADED         : "`check_field $reg_val 3  1 "0h --------" "1h ---------"`
	echo "	FAST_LINK_TIMER      : "`check_field $reg_val 2  1 "0h link timer 10ms in FIBER mode and 1.6ms in SGMII mode " "1h Link timer 2us in FIBER and SGMII mode"`
	echo "	MA_AN_RESTART        : "`check_field $reg_val 1  1 "0h Write 1h and tehn 0h to this bit caused the auto negotiation" "1h -------------"`
	echo "	MR_AN_ENABLE         : "`check_field $reg_val 0  1 "0h wirte 1 to this bit enbales the auto negotiation progess" "1h wirte 1 enable the auto-negotiation process"`
}

CPSW_SS_SGMII_STATUS_REG_j()
{
	base_addr=0x0C000014
	#the PORT_NUM should be 1-8
	#the first port num should be j 0-7: 0c000114h + j*100h
	reg_temp=`printf "0x%08x" $(($PORT_NUM*0x100+$base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_SS_SGMII_STATUS_REG_j ($reg_temp) = $reg_val  "
	echo "	LINK                  : "`check_field $reg_val 0  1 "0h link is not up" "1h link is up"`
}

CPSW_SS_STATUS_SGMII_LINK_REG()
{
	base_addr=0x0C000078
	reg_temp=`printf "0x%08x" $(($base_addr))`
	k3conf_read_reg $reg_temp
	echo "CPSW_SS_STATUS_SGMII_LINK_REG ($reg_temp) = $reg_val  "
	echo "	SGMII1_LINK          : "`check_field $reg_val 0  0 "0h No" "1h Yes"`

}

check_CPSW9G_status() {
	# configure K3conf
	oc_func
	# CPSW MDIO Alive check 
	CPSW_MDIO_ALIVE_REG
	# CPSW MDIO Link check 
	CPSW_MDIO_LINK_REG
	# CPSW statistics Port Enable Register
	#CPSW_STAT_PORT_EN_REG
	# check CPSW9G port config status
	read -p "please input your port: 1-8 "  PORT_NUM
	CTRLMMR_ENET_x_CTRL
	# check the port RGMII status
	CPSW_SS_RGMIIx_STATUS_REG
	# check the sgmii port 1
	CPSW_SS_STATUS_SGMII_LINK_REG
	# check the sgmii control reg -j
	CPSW_SS_SGMII_CONTROL_REG_j
	# sgmii status
	CPSW_SS_SGMII_STATUS_REG_j
	
}


# check the CPSW9G status
check_CPSW9G_status
#
#CPSW_MDIO_ALIVE_REG
#CTRLMMR_ENET_x_CTRL






