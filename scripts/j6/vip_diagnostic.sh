#!/bin/bash
#Author:- Nikhil Devshatwar
#This script is used for debugging issues with VIP and LVDS cameras.
#This can be used for linux based capture as well as infoadas use cases.
#For any queries, contact http://e2e.ti.com/support/omap/f/885


resolve_port()
{
	if [ $port = "vin1a" ]; then
		inst=0x48970000
		slice=0x5500
		i2cbus=11
		desAddr=0x60
		crossbar=VIP1_IRQ_1
		echo "VIP 1 Slice 0 Port A <--> LVDS cam1"
	elif [ $port = "vin2a" ]; then
		inst=0x48970000
		slice=0x5a00
		i2cbus=12
		desAddr=0x64
		crossbar=VIP1_IRQ_2
		echo "VIP 1 Slice 1 Port A <--> LVDS cam2"
	elif [ $port = "vin3a" ]; then
		inst=0x48990000
		slice=0x5500
		i2cbus=13
		desAddr=0x68
		crossbar=VIP2_IRQ_1
		echo "VIP 2 Slice 0 Port A <--> LVDS cam3"
	elif [ $port = "vin4b" ]; then
		inst=0x48990000
		slice=0x5a00
		i2cbus=15
		desAddr=0x61
		crossbar=VIP2_IRQ_2
		echo "VIP 2 Slice 1 Port B <--> LVDS cam5"
	elif [ $port = "vin5a" ]; then
		inst=0x489b0000
		slice=0x5500
		i2cbus=14
		desAddr=0x6c
		crossbar=VIP3_IRQ_1
		echo "VIP 3 Slice 0 Port A <--> LVDS cam4"
	elif [ $port = "vin6a" ]; then
		inst=0x489b0000
		slice=0x5a00
		i2cbus=16
		desAddr=0x69
		crossbar=VIP3_IRQ_2
		echo "VIP 3 Slice 1 Port A <--> LVDS cam6"
	else
		echo "Unsupported port $port"
		exit 1
	fi
}

resolve_board()
{
	basebus=1
}

parser_reg()
{
	addr=`printf "0x%08x" $(( $inst + $slice + $2 ))`
	omapconf $1 $addr $3 2>/dev/null
}

vpdma_dumpdesc()
{
	echo
	echo "VPDMA descriptor dump"
	listAddr=`printf "0x%x" $(( $inst + 0xd004 ))`
	startAddr=0x`omapconf read $listAddr 2>/dev/null`
	endAddr=`printf "0x%x" $(( $startAddr + 0x40 ))`
	omapconf dump $startAddr $endAddr 2>/dev/null

	#Print the data type
	w0Addr=`printf "0x%x" $(( $startAddr + 0x0 ))`
	word0=`omapconf read $w0Addr 2>/dev/null`
	dtype=`printf "0x%x" $(( 0x$word0 >> 26 & 0x3f))`
	echo "VPDMA data type:- $dtype"

	#Print the channel number
	w4Addr=`printf "0x%x" $(( $startAddr + 0xc ))`
	word4=`omapconf read $w4Addr 2>/dev/null`
	chan=`printf "%d" $(( 0x$word4 >> 16 & 0xff))`
	echo "VPDMA channel number used:- $chan" 

	#Print write descriptor
	echo
	echo "VPDMA write descriptor dump"
	w5Addr=`printf "0x%x" $(( $startAddr + 0x10 ))`
	word4=0x`omapconf read $w5Addr 2>/dev/null`
	wrst=`printf "0x%x" $(( $word4 & ~0x7))`
	wrend=`printf "0x%x" $(( $wrst + 0x20 ))`
	omapconf dump $wrst $wrend 2>/dev/null

	#Print size written
	fraddr=`printf "0x%x" $(( $wrst + 0x10 ))`
	frval=0x`omapconf read $fraddr 2>/dev/null`
	width=`printf "%d" $(( $frval >> 16 ))`
	height=`printf "%d" $(( $frval & 0xff ))`
	echo "Frame size written:- $width x $height"
}

ovcam() {
#ovcam [read | write] <i2cbus> <chip> <16bit addr> [<val>]
	addrlow=`printf "0x%02x" $(($4 & 0xff))`
	addrhigh=`printf "0x%02x" $(($4 >> 8))`
	i2cset -f -y $2 $3 $addrhigh $addrlow
	if [ $1 = "read" ]; then
		i2cget -f -y $2 $3
	elif [ $1 = "write" ]; then
		i2cset -f -y $2 $3 $5
	fi
}

getIRQcnt() {
#Make sure that gicirq is set correctly
	cat /proc/interrupts | grep "$gicirq" | awk '-F ' '{ print $2 }'
}

crossbar_dump() {
	echo
	echo "Crossbar mapping:-"
	mpumap=`omapconf dump crossbar 2>/dev/null | grep $crossbar`
	echo $mpumap
	echo
	mpuirq=`echo $mpumap | cut -d ' ' -f2`
	srcirq=`echo $mpumap | cut -d ' ' -f6`
	gicirq=`printf "GIC %d" $(( $mpuirq + 32 ))`
	echo "Crossbar source $srcirq $crossbar mapped to MPU $gicirq"
	cat /proc/interrupts | grep "$gicirq"
	echo
	echo "Interrupt count:- `getIRQcnt`"
}

testE()
{
	printf "=> %50s" "$1"
	if [ $2 = $3 ]; then
		echo -e "\t\tPASS"
	else
		echo -e "\t\t\tFAIL"
	fi
}

testNE()
{
	printf "=> %50s" "$1"
	if [ $2 != $3 ]; then
		echo -e "\t\tPASS"
	else
		echo -e "\t\t\tFAIL"
	fi
}

echo
echo
echo "=====================VIP diagnostic script==================="
echo  "Basic tests to debug capture issues quickly"
echo

#set -x
port="vin1a"
#Parse the cmd line args
if [ $# -gt 0 ]; then
	port=$1
	shift
fi

resolve_port
resolve_board

testE "Check if the DE-SERIALIZER is accessible"	`i2cget -f -y $basebus $desAddr 0x0`	"0xc0"
testE "Check if the SERIALIZER is connected"		`i2cget -f -y $basebus $desAddr 0x1c`	"0x03"
testE "Check if the SERIALIZER is accessible"		`i2cget -f -y $i2cbus 0x58 0x0`		"0xb0"
testE "Check if the CAMERA clock is present"		`i2cget -f -y $i2cbus 0x58 0x0c`	"0x15"
testE "Check if the CAMERA is accessible"		`ovcam read $i2cbus 0x30 0x300b`	"0x35"
testNE "Check if the parser is configured"		`parser_reg read 0x04`			"00000000"
testNE "Check if the port is detecting the frame size"	`parser_reg read 0x30`			"00000000"

vpdma_dumpdesc

crossbar_dump

echo
echo "=============================END============================="
#TODO: Check pinmux registers, check gpio data
#TODO: Check board muxes
#TODO: Calculate FPS
#TODO: Check if the sensor-cfg works for start/stop - connect/disconnect
#TODO: Check low FPS capture
#TODO: Check multi instance capture

echo "If all of these tests PASS and still there is a problem, go home :)"
echo
echo
