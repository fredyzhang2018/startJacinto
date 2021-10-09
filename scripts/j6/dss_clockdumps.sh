#!/bin/bash
# Author:- Nikhil Devshatwar
# Modified by Venkateswara Rao Mandela for HDMI PLL support
# and ADB support

#This script is used for debugging issues with DSS and LCD panels.
#It dumps all the clocks and muxes.
#For any queries, contact http://e2e.ti.com/support/omap/f/885

# Modify this string to --force <platname> if platform detection fails
FORCE_PLAT=""

# Set this variable to 1 when running against an Android Build
# The android shell has limited functionality. So this script runs
# omapconf via adb and parses the output on the host.
USE_ADB=0

# Define a function that wraps omapconf calls and removes the usual warning
# messages
oc_func() {

	if [ "$USE_ADB" -eq 1 ]; then
		OMAPCONF1="adb shell omapconf $FORCE_PLAT"
	else
		OMAPCONF1="omapconf $FORCE_PLAT"
	fi
	out_str=$($OMAPCONF1 "$@" 2>&1 | sed -e '/powerdm_deinit/d' -e '/clockdm_deinit/d' -e 's/[[:space:]]*$//')
	echo "$out_str"
}
OMAPCONF=oc_func

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

# Dump a register value given the address and the register name
# also exports a variable of the given name with the read value
dump_reg() {
	reg=$1
	regname=$2
	local __outname=$2
	val=0x$($OMAPCONF read "$reg")
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
	val=0x$($OMAPCONF read "$addr")
	fld=`printf "0x%08x" $(( $val >> $shift ))`
	fld=`printf "%d" $(( $fld & $mask ))`
	echo $fld
}

dump_dpll() {
	inst=$1
	if [ $inst = "video1" ]; then
		base=0x58004300
	elif [ $inst = "video2" ]; then
		base=0x58009300
	elif [ $inst = "hdmi" ]; then
		base=0x58040200
	else
		echo "ERROR: Unknown DPLL instance $inst"
		exit
	fi

	echo "========================================================"
	end=`printf "0x%08x" $(( $base + 0x20 ))`
	echo "Register dump for DPLL $inst"
	$OMAPCONF dump $base $end

	#Interprete the regdump

	addr=`printf "0x%08x" $(( $base + 0x4 ))`
	val=0x$($OMAPCONF read "$addr")
	echo "Details for DPLL $inst"
	pllstat=`check_field $val  1 1 "inactive" "Locked"`
	m4stat=`check_field $val  7 1 "inactive" "Active"`
	m5stat=`check_field $val  8 1 "inactive" "Active"`
	m6stat=`check_field $val 10 1 "inactive" "Active"`
	m7stat=`check_field $val 11 1 "inactive" "Active"`
	echo "PLL status  : "	$pllstat
	echo "M4 hsdiv(1) : "	$m4stat
	echo "M5 hsdiv(2) : "	$m5stat
	echo "M6 hsdiv(3) : "	$m6stat
	echo "M7 hsdiv(4) : "	$m7stat
	echo

	#Print the multipliers/dividers
	regm=`get_field $base 0x0c  9 0xfff`
	regn=`get_field $base 0x0c  1 0xff`
	m4div=`get_field $base 0x0c 21 0x1f`
	m6div=`get_field $base 0x14  0 0x1f`
	m7div=`get_field $base 0x14  5 0x1f`
	echo "PLL_REGM   = " $regm
	echo "PLL_REGN   = " $regn
	echo "M4 DIV     = " $m4div
	echo "M6 DIV     = " $m6div
	echo "M7 DIV     = " $m7div

	if [ $inst = "hdmi" ]; then
		regm2=`get_field $base 0x20 18 0x7f`
		regm_f=`get_field $base 0x20 0 0x1ffff`
		echo "PLL_REGM2  = " $regm2
		echo "PLL_REGM_F = " $regm2

		pll_sd=`get_field $base 0x14 10 0xff`
		echo "PLL_SD  = " $pll_sd

		addr=`printf "0x%08x" $(( $base + 0x18 ))`
		val=0x$($OMAPCONF read "$addr")
		echo "HDMI_SSC_CONFIGURATION1(should be zero) $val"

		addr=`printf "0x%08x" $(( $base + 0x1c ))`
		val=0x$($OMAPCONF read "$addr")
		echo "HDMI_SSC_CONFIGURATION2(should be zero) $val"

	fi
	echo

	#Calculate clkouts
	echo "Clock calculations (DPLL $inst)"
	if [ $inst = "hdmi" ]; then
		dcoclk=$(( sysclk * $regm / ( ($regn + 1) * ($regm2)) ))
		if [ $pllstat = "inactive" ]; then dcoclk=0; fi
		echo "sysclk = $sysclk"
		echo "CLKOUT = sysclk * REGM / (REGM2 * (REGN + 1)) = $dcoclk"
		echo
		eval "$inst"_pll=$dcoclk;
	else
		dcoclk=$(( sysclk * 2 * $regm / ($regn + 1) ))
		if [ $pllstat = "inactive" ]; then dcoclk=0; fi
		m4clk=$(( $dcoclk / ($m4div + 1)))
		if [ $m4stat = "inactive" ]; then m4clk=0; fi
		m6clk=$(( $dcoclk / ($m6div + 1)))
		if [ $m6stat = "inactive" ]; then m6clk=0; fi
		m7clk=$(( $dcoclk / ($m7div + 1)))
		if [ $m7stat = "inactive" ]; then m7clk=0; fi
		echo "sysclk = $sysclk"
		echo "DCO clk = sysclk * 2 * REGM / (REGN + 1) = $dcoclk"
		echo "M4clk (clkcout1) = DCO clk / (M4 DIV + 1) = $m4clk"
		echo "M6clk (clkcout3) = DCO clk / (M6 DIV + 1) = $m6clk"
		echo "M7clk (clkcout4) = DCO clk / (M7 DIV + 1) = $m7clk"
		echo

		eval "$inst"_pll=$dcoclk;
		eval "$inst"_m4=$m4clk;
		eval "$inst"_m6=$m6clk;
		eval "$inst"_m7=$m7clk;
	fi
}

init_dpll_values() {
	inst=$1
	eval "$inst"_pll=0
	eval "$inst"_m4=0
	eval "$inst"_m6=0
	eval "$inst"_m7=0
}

dump_dss_clk_regs() {

	dump_reg "0x4A009100" "CM_DSS_CLKSTCTRL"
	dump_reg "0x4A009120" "CM_DSS_DSS_CLKCTRL"
}

dump_dss_clk_mux() {
	dss_pll=0x4a002538
	val=0x$($OMAPCONF read "$dss_pll")
	echo "CTRL_CORE_DSS_PLL_CONTROL ($dss_pll) = $val"
	echo "video1 PLL : "	`check_field $val 0 1 "Enabled" "Disabled"`
	echo "video2 PLL : "	`check_field $val 1 1 "Enabled" "Disabled"`
	echo "HDMI   PLL : "	`check_field $val 2 1 "Enabled" "Disabled"`
	echo "DSI1_A_CLK mux : "`check_field $val 3 3 "DPLL Video1" "DPLL HDMI"`
	echo "DSI1_B_CLK mux : "`check_field $val 5 3 "DPLL Video1" "DPLL video2" "DPLL HDMI" "DPLL ABE"`
	echo "DSI1_C_CLK mux : "`check_field $val 7 3 "DPLL Video2" "DPLL Video1" "DPLL HDMI"`
	echo

	dss_ctrl=0x58000040
	val=0x$($OMAPCONF read "$dss_ctrl")
	echo "DSS_CTRL ($dss_ctrl) = $val"
	echo " 2: LCD1 clk switch : "	`check_field $val  0 1 "DSS clk" "DSI1_A_CLK"`
	echo " 3: LCD2 clk switch : "	`check_field $val 12 1 "DSS clk" "DSI1_B_CLK"`
	echo "10: LCD3 clk switch : "	`check_field $val 19 1 "DSS clk" "DSI1_C_CLK"`
	echo " 1: func clk switch : "	`check_field $val  7 3 "DSS clk" "DSI1_A_CLK" "DSI1_B_CLK" "HDMI_CLK" "DSI1_C_CLK"`
	echo "13: DPI1 output     : "	`check_field $val 16 3 "HDMI" "LCD1" "LCD2" "LCD3"`
	echo

	dss_status=0x5800005C
	val=0x$($OMAPCONF read "$dss_status")
	echo "DSS_STATUS ($dss_status) = $val"
	echo

	dsi_clk_ctrl=0x58004054
	val=0x$($OMAPCONF read "$dsi_clk_ctrl")
	echo "DSI_CLK_CTRL ($dsi_clk_ctrl) = $val"
	echo
}

dss_clk_print() {
	echo "========================================================"
	echo "Clock O/P of MUXes"
	dss_clk=$($OMAPCONF show dpll | grep -A3 "H12 Output" | grep Speed | head -1 | cut -d '|' -f6)
	dss_clk=$(( $dss_clk * 1000000 ))
	echo "DPLL PER H12 Output $dss_clk"
	dump_reg "0x4A00815C" "CM_DIV_H12_DPLL_PER"

	dss_pll=0x4a002538
	val=0x$($OMAPCONF read "$dss_pll")
	dsia_clk=`check_field $val 3 3 $video1_m4 $hdmi_pll`
	dsib_clk=`check_field $val 5 3 $video1_m6 $video2_m6 $hdmi_pll "DPLL ABE"`
	dsic_clk=`check_field $val 7 3 $video2_m4 $video1_m6 $hdmi_pll`
	echo "DSI1_A_CLK : " $dsia_clk
	echo "DSI1_B_CLK : " $dsib_clk
	echo "DSI1_C_CLK : " $dsic_clk
	echo 

	dss_ctrl=0x58000040
	val=0x$($OMAPCONF read "$dss_ctrl")
	lcd1_clk=`check_field $val  0 1 $dss_clk $dsia_clk`
	lcd2_clk=`check_field $val 12 1 $dss_clk $dsib_clk`
	lcd3_clk=`check_field $val 19 1 $dss_clk $dsic_clk`
	hdmi_clk=`check_field $val  7 3 $dss_clk $dsia_clk $dsib_clk $hdmi_clk $dsic_clk`

	dump_reg "0x58001804" "DISPC_DIVISOR"

	echo " 2: LCD1 clk : "	$lcd1_clk
	echo " 3: LCD2 clk : "	$lcd2_clk
	echo "10: LCD3 clk : "	$lcd3_clk
	echo " 1: func clk : "	$hdmi_clk
	echo 

	lcd1=`get_field 0x58001070 0x0 16 0xff`
	lcd2=`get_field 0x5800140c 0x0 16 0xff`
	lcd3=`get_field 0x58001838 0x0 16 0xff`
	lcd1_lclk=0; if [ $lcd1_clk != "0" ]; then lcd1_lclk=$(( $lcd1_clk / $lcd1 )); fi
	lcd2_lclk=0; if [ $lcd2_clk != "0" ]; then lcd2_lclk=$(( $lcd2_clk / $lcd2 )); fi
	lcd3_lclk=0; if [ $lcd3_clk != "0" ]; then lcd3_lclk=$(( $lcd3_clk / $lcd3 )); fi
	pcd1=`get_field 0x58001070 0x0  0 0xff`
	pcd2=`get_field 0x5800140c 0x0  0 0xff`
	pcd3=`get_field 0x58001838 0x0  0 0xff`
	lcd1_pclk=0; if [ $lcd1_clk != "0" ]; then lcd1_pclk=$(( $lcd1_lclk / $pcd1 )); fi
	lcd2_pclk=0; if [ $lcd2_clk != "0" ]; then lcd2_pclk=$(( $lcd2_lclk / $pcd2 )); fi
	lcd3_pclk=0; if [ $lcd3_clk != "0" ]; then lcd3_pclk=$(( $lcd3_lclk / $pcd3 )); fi
	echo "LCD1 logic clk(/" $lcd1 ") : " $lcd1_lclk " pix clk(/" $pcd1 ") : " $lcd1_pclk
	echo "LCD2 logic clk(/" $lcd2 ") : " $lcd2_lclk " pix clk(/" $pcd2 ") : " $lcd2_pclk
	echo "LCD3 logic clk(/" $lcd3 ") : " $lcd3_lclk " pix clk(/" $pcd3 ") : " $lcd3_pclk
	echo 
}

echo
echo
echo "=====================DSS clock script==================="
echo  "Dumps internal clocks and muxes of DSS"
echo

#set -x
sysclk=20000000
dss_pll=0x4a002538

dump_dss_clk_mux

dump_dss_clk_regs

init_dpll_values video1
init_dpll_values video2
init_dpll_values hdmi

status=`get_field $dss_pll 0x0  0 0x1`
if [ $status = "0" ]; then
	dump_dpll video1
fi

status=`get_field $dss_pll 0x0  1 0x1`
if [ $status = "0" ]; then
	dump_dpll video2
fi

status=`get_field $dss_pll 0x0  2 0x1`
if [ $status = "0" ]; then
	dump_dpll hdmi
fi

dss_clk_print
