#!/bin/sh

# This distribution contains contributions or derivatives under copyright
# as follows:
#
# Copyright (c) 2010, Texas Instruments Incorporated
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# - Neither the name of Texas Instruments nor the names of its
#   contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

cwd=`dirname $0`
. $cwd/common.sh


minicomcfg=${HOME}/.minirc.dfl

cat << EOM

--------------------------------------------------------------------------------"
This step will set up minicom (serial communication application) for
SDK development


For boards that contain a USB-to-Serial converter on the board such as:
	* BeagleBone
	* Beaglebone Black
	* AM335x EVM-SK
	* AM57xx EVM
	* K2H, K2L, and K2E EVMs

the port used for minicom will be automatically detected. By default Ubuntu
will not recognize this device. Setup will add a udev rule to
/etc/udev/ so that from now on it will be recognized as soon as the board is
plugged in.

For other boards, the serial will defualt to /dev/ttyS0. Please update based
on your setup.

--------------------------------------------------------------------------------

EOM

portdefault=/dev/ttyS0

echo ""
echo "NOTE: If your using any of the above boards simply hit enter"
echo "and the correct port will be determined automatically at a"
echo "later step.  For all other boards select the serial port"
echo "that the board is connected to."
echo "Which serial port do you want to use with minicom?"
read -p "[ $portdefault ] " port

if [ ! -n "$port" ]; then
    port=$portdefault
fi

if [ -f $minicomcfg ]; then
    cp $minicomcfg $minicomcfg.old
    echo
    echo "Copied existing $minicomcfg to $minicomcfg.old"
fi

echo "pu port             $port
pu baudrate         115200
pu bits             8
pu parity           N
pu stopbits         1
pu minit
pu mreset
pu mdialpre
pu mdialsuf
pu mdialpre2
pu mdialsuf2
pu mdialpre3
pu mdialsuf3
pu mconnect
pu mnocon1          NO CARRIER
pu mnocon2          BUSY
pu mnocon3          NO DIALTONE
pu mnocon4          VOICE
pu rtscts           No" | tee $minicomcfg > /dev/null
check_status

echo
echo "Configuration saved to $minicomcfg. You can change it further from inside"
echo "minicom, see the Software Development Guide for more information."
echo "--------------------------------------------------------------------------------"
