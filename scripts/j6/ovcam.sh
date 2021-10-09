#!/bin/bash
#set -x

usage()
{
	echo -e "\t\t ovcam v1.0"
	echo -e "\tUtility for reading/writing to OVcamera"
	echo -e "\tOV camera uses SCCB (Serial Camera Control Bus)"
	echo -e "\tfor read/write of registers which are 16bit addressed"
	echo -e "\tThis uses SMbus protocol to emulate the master_xfer"
	echo -e "\tUsage:-"
	echo -e "\t    ovcam read | write <16bit address> [<value>]"
	echo -e "\t        e.g. ovcam read  0x3003"
	echo -e "\t        e.g. ovcam write 0x3005 0x20"
	echo
	exit
}

#ovcam [r|w] <addr> <val>
BUS=1
CHIP=0x30
if [ $# -le 1 -o $# -ge 4 ]; then
	usage
fi
ADDR=$2
VAL=$3

        addrlow=`printf "0x%02x" $(($ADDR & 0xff))`
        addrhigh=`printf "0x%02x" $(($ADDR >> 8))`
        i2cset -f -y $BUS $CHIP $addrhigh $addrlow $VAL i
        if [ $1 = "read" ]; then
                i2cget -f -y $BUS $CHIP
        fi

