#!/bin/bash
# Author:- Venkateswara Rao Mandela

# Dump DSS dispc registers on DRA7xx
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

read_reg() {
    var=$($OMAPCONF read "$1")
    echo "| $1    | 0x$var |"
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

echo "|----------------------------|
| Address (hex) | Data (hex) |
|----------------------------|"

# DSS Register Mapping Summary. Table 11-17
read_reg 0x58000000
read_reg 0x58000010
read_reg 0x58000014
read_reg 0x58000040
read_reg 0x5800005C

# OCP2SCP2 Register Mapping Summary. Table 11-26
read_reg 0x4A0A0000
read_reg 0x4A0A0010
read_reg 0x4A0A0014
read_reg 0x4A0A0018

# Table 11-79, 11-80 DSI registers
read_reg 0x58004054
read_reg 0x58005054

echo "|----------------------------|"


# Video 1 PLL registers
base=0x58004300
end=0x58004320
$OMAPCONF dump $base $end

# HDMI PLL registers
base=0x58040200
end=0x58040220
$OMAPCONF dump $base $end

dss_pll=0x4a002538
status=$(get_field $dss_pll 0x0  1 0x1)
if [ "$status" = "0" ]; then
    # Video 2 PLL registers
    base=0x58009300
    end=0x58009320
    $OMAPCONF dump $base $end
fi

# HDMI WP registers
base=0x58040000
end=0x58040094
$OMAPCONF dump $base $end

base=0x58001000
end=0x58001700
$OMAPCONF dump $base $end

base=0x58001700
end=0x58001800
$OMAPCONF dump $base $end

base=0x58001800
end=0x58001870
$OMAPCONF dump $base $end
