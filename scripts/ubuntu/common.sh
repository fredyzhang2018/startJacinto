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

check_status() {
    ret=$?
    if [ "$ret" -ne "0" ]; then
        echo "Failed setup, aborting.."
        exit 1
    fi
}

# This function will return the code name of the Linux host release to the caller
get_host_type() {
    local  __host_type=$1
    local  the_host=`lsb_release -a 2>/dev/null | grep Codename: | awk {'print $2'}`
    eval $__host_type="'$the_host'"
}

# This function returns the version of the Linux host to the caller
get_host_version() {
    local  __host_ver=$1
    local  the_version=`lsb_release -a 2>/dev/null | grep Release: | awk {'print $2'}`
    eval $__host_ver="'$the_version'"
}

# This function returns the major version of the Linux host to the caller
# If the host is version 12.04 then this function will return 12
get_major_host_version() {
    local  __host_ver=$1
    get_host_version major_version
    eval $__host_ver="'${major_version%%.*}'"
}

# This function returns the minor version of the Linux host to the caller
# If the host is version 12.04 then this function will return 04
get_minor_host_version() {
    local  __host_ver=$1
    get_host_version minor_version
    eval $__host_ver="'${minor_version##*.}'"
}

# This function will look for an FTDI connection from the development board
# and based on the index passed in it will set the .minirc.dfl value for the
# proper FTDI instance.
set_ftdi_serial_port() {
    index="$1"
    port=""
    ports=""

    if [ ! -n "$index" ]
    then
        index=1
    fi

    while [ 1 == 1 ]
    do
        echo "Detecting connection to board..."
        loopCount=0
        ports=`dmesg | grep FTDI | grep "tty" | tail -2 | sed s'/.*attached to //g'`
		while [ -z "$ports" ] && [ "$loopCount" -ne "10" ]
		do
			#count to 10 and timeout if no connection is found
			loopCount=$((loopCount+1))

			sleep 1
            ports=`dmesg | grep FTDI | grep "tty" | tail -2 | sed s'/.*attached to //g'`
		done

        # If we have actually found ports then get the proper index
		if [ -n "$ports" ]; then
            i=1
            for p in $ports
            do
                if [ "$i" -eq "$index" ]
                then
                    port="$p"
                    break
                # There should not be more than 10 indexes so stop there
                elif [ "$i" -eq "10" ]
                then
                    break
                fi
                i=`expr $i + 1`
            done

            # If the port is blank then we couldn't find the index so ask the
            # user.
            if [ "x$port" == "x" ]
            then
                echo "The port for the FTDI USB-to-Serial device could not be"
                echo "found.  Please enter the port yourself here"
                read -p "[ /dev/ttyUSB# ] " port
            fi
			break;
		fi

		# if we didn't find a port and reached the timeout limit then ask
        # to reconnect
		if [ -z "$ports" ] && [ "$loopCount" = "10" ]; then
			echo ""
			echo "Unable to detect which port the board is connected to."
			echo "Please reconnect your board."
			echo "Press 'y' to attempt to detect your board again or press 'n' to continue..."
			read -p "(y/n)" retryBoardDetection
		fi

		#if they choose not to retry, ask user to reboot manually and exit
		if [ "$retryBoardDetection" = "n" ]; then
			echo ""
			echo "Please reboot your board manually and connect using minicom."
			exit;
		fi
	done

    # Take everything in the user's .minirc.dlf file expect the port setting
    cat ${HOME}/.minirc.dfl | grep -v port > ${HOME}/.minirc.dfl.tmp
    echo "pu port           /dev/$port" > ${HOME}/.minirc.dfl
    cat ${HOME}/.minirc.dfl.tmp >> ${HOME}/.minirc.dfl
    rm -f ${HOME}/.minirc.dfl.tmp
}
