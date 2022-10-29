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

# Minimum major Linux version for adding dialout group
min_ver_upper=12

get_host_type host
get_major_host_version host_upper

username=`echo $USER`

# Only execute if the Linux version is above 12.xx
if [ "$host_upper" -gt "$min_ver_upper" -o "$host_upper" -eq "$min_ver_upper" ]; then

    cat /etc/group | grep dialout > /dev/null
    if [ `echo $?` -eq '0' ]
    then
        echo "Starting with Ubuntu 12.04 serial devices are only accessible by members of the 'dialout' group."
        echo "A user must be apart of this group to have the proper permissions to access a serial device."
        echo

        if [ $username = "root" ]
        then
            echo "Are you running this script using sudo? The detected username is 'root'."
            echo "Verify and enter your Linux username below"
            read -p "[ root ] " entered_username
            echo

            if [ -n "$entered_username" ]
            then
                username=$entered_username
            fi

            cat /etc/passwd | cut -d":" -f1 | grep $username > /dev/null
            if [ `echo $?` = '1' ]
            then
                echo "Invalid username entered."
                return 1
            fi
        fi

        groups $username | grep dialout > /dev/null
        if [ `echo $?` = '1' ]
        then
            echo "This script will automatically add the user '$username' to the 'dialout' group"

            sudo usermod -a -G dialout $username > /dev/null
            if [ `echo $?` -eq '0' ]
            then
                echo "Your user was successfully added to the 'dialout' group."
                echo
                echo "Unfortunately, once a user is added to the 'dialout' group the change won't be picked up until the user logouts."
            else
                echo "Failed to add user '$username'  to 'dialout' group"
                echo
                echo "You will need to add your user to the 'dialout' group"

            fi

            echo "Until then you will be required to use sudo when accessing a serial device."
            echo "Please logout now and log back in so that the group changes are in effect."
            echo
            read -p "Press return to continue" REPLY
            exit 0

        else
            echo "User '$username' is already apart of the 'dialout' group"
        fi

        echo
    fi
fi
