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

#~ SDKinstall=`grep TI_SDK_PATH= $cwd/../Rules.make | cut -d= -f2`

sj_nfs_usage()
{
	echo "# setup-target-nfs.sh - To setup the targetfs"
	echo "# setup-target-nfs.sh --help  | -h - To display this"
    echo "# setup-target-nfs.sh --path  | -p  TARGETFS_PATH "
}

sj_nfs_check_args()
{

	valid_args=(--help -h --path -p)
	if [ "$1" == "" ]
	then
		return 0
	fi
	for i in "${valid_args[@]}"
	do
		if [ "$1" == "$i" ]
		then
			return 0
		fi
	done
	sj_usage
}


sj_nfs_parse_args()
{  
    echo "[ $(date) ] >>> NFS PATH = $1 >>>>> \n" 
    echo "[ $(date) ] >>> NFS PATH = $1 >>>>> \n" > $SJ_PATH_JACINTO/.sj_log
}

sj_nfs_start()
{
    dst=$1
    echo "[ $(date) ] >>> nfs setting & start = $dst >>>>> \n" 
    if [ -d $dst ]; then
        echo $dst > ./.targetfs
        echo
        echo "--------------------------------------------------------------------------------"
        echo "This step will export your target filesystem for NFS access."
        echo
        echo "Note! This command requires you to have administrator priviliges (sudo access) "
        echo "on your host."
        read -p "Press return to continue" REPLY
        grep $dst /etc/exports > /dev/null
        if [ "$?" -eq "0" ]; then
            echo "$dst already NFS exported, skipping.."
        else
            sudo chmod 666 /etc/exports
            check_status
            sudo echo "$dst *(rw,nohide,insecure,no_subtree_check,async,no_root_squash)" >> /etc/exports
            check_status
            sudo chmod 644 /etc/exports
            check_status
        fi
        
        echo
        sudo /etc/init.d/nfs-kernel-server stop
        check_status
        sleep 1
        sudo /etc/init.d/nfs-kernel-server start
        check_status
        echo "--------------------------------------------------------------------------------"
    else 
        echo "$1 is not exist"
    fi
    
}


# Start from here
echo "Start: $0 $1 PATH=$2"
sj_nfs_check_args $1
sj_nfs_parse_args $2
case $1 in
	"--help" | "-h")
		sj_nfs_usage
		;;
	"--path" | "-p")
        sj_nfs_start $2
		;;
	"")
        "input is not correct"
		;;
esac


