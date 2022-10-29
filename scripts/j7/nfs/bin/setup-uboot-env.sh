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

do_expect() {
    echo "expect {" >> $3
    check_status
    echo "    $1" >> $3
    check_status
    echo "}" >> $3
    check_status
    echo $2 >> $3
    check_status
    echo >> $3
}
echo
echo "# fredy test >>> $0 $1 $2  "
echo
echo
echo "--------------------------------------------------------------------------------"
echo "This step will set up the u-boot variables for booting the EVM."
echo "--------------------------------------------------------------------------------"

ipdefault=`ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d/ -f1 | awk '{ print $2 }'`
platform=j7-evm


# Configure prompt for U-Boot 2016.05
prompt="=>"


echo "Autodetected the following ip address of your host, correct it if necessary"
read -p "[ $ipdefault ] " ip
echo

if [ ! -n "$ip" ]; then
    ip=$ipdefault
fi
echo " SCRIPTS PATH = $2"
if [ -f $2/ubuntu/.targetfs ]; then #$2 scripts path
    echo "[ `date` ]:  $2/ubuntu/.targetfs"
    rootpath=`cat $2/ubuntu/.targetfs`
else
    echo "Where is your target filesystem extracted?"
    exit 1
fi

kernelimage="Image-""$platform"".bin"
kernelimagesrc=`ls -1 $1/../board-support/prebuilt-images/$kernelimage` #$1 sdk path
kernelimagedefault=`basename $kernelimagesrc`

echo "Select Linux kernel location:"
echo " 1: TFTP"
echo " 2: SD card"
echo
read -p "[ 1 ] " kernel

if [ ! -n "$kernel" ]; then
    kernel="1"
fi

echo
echo "Select root file system location:"
echo " 1: NFS"
echo " 2: SD card"
echo
read -p "[ 1 ] " fs

if [ ! -n "$fs" ]; then
    fs="1"
fi



if [ "$kernel" -eq "1" ]; then
    echo
    echo "Available kernel images in /tftproot:"
    for file in /tftpboot/*; do
	basefile=`basename $file`
	echo "    $basefile"
    done
    echo
    echo "Which kernel image do you want to boot from TFTP?"
    read -p "[ $kernelimagedefault ] " kernelimage

    if [ ! -n "$kernelimage" ]; then
	kernelimage=$kernelimagedefault
    fi
else
    kernelimage=Image
fi

board="unknown"
check_for_board() {
    lsusb -vv -d 0403:6011 > /dev/null 2>&1

    if [ "$?" = "0" ]
    then
        board="am65x"
    fi
}

echo "timeout 300" > $cwd/setupBoard.minicom
echo "verbose on" >> $cwd/setupBoard.minicom
do_expect "\"stop autoboot:\"" "send \" \"" $cwd/setupBoard.minicom

# Reboot with clean environment
do_expect "\"$prompt\"" "send \"env default -f -a\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"saveenv\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"reset\"" $cwd/setupBoard.minicom
do_expect "\"stop autoboot:\"" "send \" \"" $cwd/setupBoard.minicom

# Configurable settings
do_expect "\"$prompt\"" "send \"setenv serverip $ip\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv nfs_root $rootpath\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv name_kern $kernelimage\"" $cwd/setupBoard.minicom

# General macros
do_expect "\"$prompt\"" "send \"setenv bootcmd 'run findfdt; run envboot; run setup_\${kern_boot}; run init_\${rootfs_boot}; run get_kern_\${kern_boot}; run get_fdt_\${kern_boot}; run get_overlay_\${kern_boot}; run run_kern'\"" $cwd/setupBoard.minicom

do_expect "\"$prompt\"" "send \"setenv init_net 'run args_all args_net; setenv autoload no; dhcp'\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv args_net 'setenv bootargs console=\${console} \${optargs} rootfstype=nfs root=/dev/nfs rw nfsroot=\${serverip}:\${nfs_root},\${nfs_options} ip=dhcp'\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv get_kern_net 'tftp \${loadaddr} \${name_kern}'\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv get_fdt_net 'tftp \${fdtaddr} \${name_fdt}'\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv get_overlay_net 'fdt address \${fdtaddr};fdt resize 0x100000;for overlay in \${overlay_files};do;tftp \${overlayaddr} \${overlay};fdt apply \${overlayaddr}; done'\"" $cwd/setupBoard.minicom

do_expect "\"$prompt\"" "send \"setenv nfs_options 'nolock,v3,tcp,rsize=4096,wsize=4096'\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv setup_mmc ''\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"setenv setup_net 'setenv autoload no; dhcp'\"" $cwd/setupBoard.minicom



if [ "$kernel" -eq "1" ]; then
	do_expect "\"$prompt\"" "send \"setenv kern_boot net\"" $cwd/setupBoard.minicom
else
	do_expect "\"$prompt\"" "send \"setenv kern_boot mmc\"" $cwd/setupBoard.minicom
fi

if [ "$fs" -eq "1" ]; then
	do_expect "\"$prompt\"" "send \"setenv rootfs_boot net\"" $cwd/setupBoard.minicom
else
	do_expect "\"$prompt\"" "send \"setenv rootfs_boot mmc\"" $cwd/setupBoard.minicom
fi
do_expect "\"$prompt\"" "send \"saveenv\"" $cwd/setupBoard.minicom
do_expect "\"$prompt\"" "send \"boot\"" $cwd/setupBoard.minicom
#echo "! killall -s SIGHUP minicom" >> $cwd/setupBoard.minicom

echo "--------------------------------------------------------------------------------"
echo "Would you like to create a minicom script with the above parameters (y/n)?"
read -p "[ y ] " minicom
echo

if [ ! -n "$minicom" ]; then
    minicom="y"
fi

if [ "$minicom" = "y" ]; then

    echo -n "Successfully wrote "
    readlink -m $cwd/setupBoard.minicom

    while [ yes ]
    do
        check_for_board

        if [ "$board" != "unknown" ]
        then
            break
        else
            echo ""
            echo "Board could not be detected. Please connect the board to the PC."
            read -p "Press any key to try checking again." temp
        fi
    done

    if [ "$board" != "unknown" ]
    then
        ftdiInstalled=`lsmod | grep ftdi_sio`
        if [ -z "$ftdiInstalled" ]
        then
            sudo modprobe -q ftdi_sio
        fi

        while [ yes ]
        do
            echo ""
            echo -n "Detecting connection to board... "
            loopCount=0
            serial_number=`sudo lsusb -v -d 0403:6011 | grep iSerial | awk '{ print $NF }'`
            usb_id=`dmesg | grep "SerialNumber: $serial_number" | tail -1 | awk '{ print $3 }'`
            port=`dmesg | grep FTDI | grep "tty" | grep "$usb_id" | tail -4 | head -1 | grep "attached" |  awk '{ print $NF }'`
            while [ -z "$port" ] && [ "$loopCount" -ne "10" ]
            do
                #count to 10 and timeout if no connection is found
                loopCount=$((loopCount+1))

                sleep 1
                serial_number=`sudo lsusb -v -d 0403:6011 | grep iSerial | awk '{ print $NF }'`
                usb_id=`dmesg | grep "SerialNumber: $sn" | tail -1 | awk '{ print $3 }'`
                port=`dmesg | grep FTDI | grep "tty" | grep "usb $usb_id" | tail -4 | head -1 | grep "attached" |  awk '{ print $NF }'`
            done

            #check to see if we actually found a port
            if [ -n "$port" ]; then
                echo "/dev/$port"
                break;
            fi

            #if we didn't find a port and reached the timeout limit then ask to reconnect
            if [ -z "$port" ] && [ "$loopCount" = "10" ]; then
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

        sed -i -e "s|^pu port.*$|pu port             /dev/$port|g" ${HOME}/.minirc.dfl
    fi

    echo
    echo "--------------------------------------------------------------------------------"
    echo "Would you like to run the setup script now (y/n)?"
    echo
    echo "Please connect the ethernet cable as described in the Quick Start Guide."
    echo "Once answering 'y' on the prompt below, you will have 300 seconds to connect"
    echo "the board and power cycle it before the setup times out"
    echo
    echo "After successfully executing this script, your EVM will be set up. You will be "
    echo "able to connect to it by executing 'minicom -w' or if you prefer a windows host"
    echo "you can set up Tera Term as explained in the Software Developer's Guide."
    echo "If you connect minicom or Tera Term and power cycle the board Linux will boot."
    echo
    read -p "[ y ] " minicomsetup

    if [ ! -n "$minicomsetup" ]; then
       minicomsetup="y"
    fi

    if [ "$minicomsetup" = "y" ]; then
      cd $cwd
      echo "# fredy : test minicom cat $cwd "
      sudo chmod 777 setupBoard.minicom 
      sudo minicom -w -S setupBoard.minicom
    fi

    echo "You can manually run minicom in the future with this setup script using: minicom -S $cwd/setupBoard.minicom"
    echo "--------------------------------------------------------------------------------"

fi
