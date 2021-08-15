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

tftpcfg=/etc/xinetd.d/tftp
tftprootdefault=/home/$USER/tftpboot

tftp() {
    echo "
service tftp
{
protocol = udp
port = 69
socket_type = dgram
wait = yes
user = nobody
server = /usr/sbin/in.tftpd
server_args = $tftproot
disable = no
}
" | sudo tee $tftpcfg > /dev/null
     check_status
     echo
     echo "$tftpcfg successfully created"
}

#~ prebuiltimagesdir=`cd $cwd/../board-support/prebuilt-images/ ; echo $PWD`
#~ copy_to_tftproot() {
    #~ files="$1"
    #~ for file in $files
    #~ do
	#~ if [ -f $tftproot/$file ]; then
	    #~ echo
	    #~ echo "$tftproot/$file already exists. The existing installed file can be renamed and saved under the new name."
	    #~ echo "(o) overwrite (s) skip copy "
	    #~ read -p "[o] " exists
	    #~ case "$exists" in
	      #~ s) echo "Skipping copy of $file, existing version will be used"
		 #~ ;;
	      #~ *) sudo cp "$prebuiltimagesdir/$file" $tftproot
		 #~ check_status
		 #~ echo
		 #~ echo "Successfully overwritten $file in tftp root directory $tftproot"
		 #~ ;;
	    #~ esac
	#~ else
	    #~ sudo cp "$prebuiltimagesdir/$file" $tftproot
	    #~ check_status
	    #~ echo
	    #~ echo "Successfully copied $file to tftp root directory $tftproot"
	#~ fi
    #~ done
#~ }

echo "--------------------------------------------------------------------------------"
echo "Which directory do you want to be your tftp root directory?(if this directory does not exist it will be created for you)"
read -p "[ $tftprootdefault ] " tftproot

if [ ! -n "$tftproot" ]; then
    tftproot=$tftprootdefault
fi
echo $tftproot > ./.tftproot
echo "--------------------------------------------------------------------------------"

echo
echo "--------------------------------------------------------------------------------"
echo "This step will set up the tftp server in the $tftproot directory."
echo
echo "Note! This command requires you to have administrator priviliges (sudo access) "
echo "on your host."
read -p "Press return to continue" REPLY

if [ -d $tftproot ]; then
    echo
    echo "$tftproot already exists, not creating.."
else
    sudo mkdir -p $tftproot
    check_status
    sudo chmod 777 $tftproot
    check_status
    sudo chown nobody $tftproot
    check_status
fi

#~ platform=`cat $cwd/../Rules.make | grep -e "^PLATFORM=" | cut -d= -f2`
#~ kernelimage="*Image-""$platform"".bin"
#~ kernelimagesrc=`ls -1 $cwd/../board-support/prebuilt-images/$kernelimage`
#~ if [ -f $tftproot/$kernelimage ]; then
    #~ echo
    #~ echo "$tftproot/$kernelimage already exists. The existing installed file can be renamed and saved under the new name."
    #~ echo "(r) rename (o) overwrite (s) skip copy "
    #~ read -p "[r] " exists
    #~ case "$exists" in
      #~ s) echo "Skipping copy of $kernelimage, existing version will be used"
         #~ ;;
      #~ o) sudo cp $kernelimagesrc $tftproot
         #~ check_status
         #~ echo
         #~ echo "Successfully overwritten $kernelimage in tftp root directory $tftproot"
         #~ ;;
      #~ *) dte="`date +%m%d%Y`_`date +%H`.`date +%M`"
         #~ echo "New name for existing kernelimage: "
         #~ read -p "[ $kernelimage.$dte ]" newname
         #~ if [ ! -n "$newname" ]; then
             #~ newname="$kernelimage.$dte"
         #~ fi
         #~ sudo mv "$tftproot/$kernelimage" "$tftproot/$newname"
         #~ check_status
         #~ sudo cp $kernelimagesrc $tftproot
         #~ check_status
         #~ echo
         #~ echo "Successfully copied $kernelimage to tftp root directory $tftproot as $newname"
         #~ ;;
    #~ esac
#~ else
    #~ sudo cp $kernelimagesrc $tftproot
    #~ check_status
    #~ echo
    #~ echo "Successfully copied $kernelimage to tftp root directory $tftproot"
#~ fi

#~ dtbfiles=`cd $prebuiltimagesdir;ls -1 *.dtb`
#~ copy_to_tftproot "$dtbfiles"

#~ dtbofiles=`cd $prebuiltimagesdir;ls -1 *.dtbo`
#~ copy_to_tftproot "$dtbofiles"

#~ uboot_gph_files=`cd $prebuiltimagesdir;ls -1 u-boot*.gph 2> /dev/null`
#~ copy_to_tftproot "$uboot_gph_files"

#~ monfiles=`cd $prebuiltimagesdir;ls -1 skern*.bin 2> /dev/null`
#~ copy_to_tftproot "$monfiles"

#~ fw_files=`cd $prebuiltimagesdir;ls -1 *firmware*.bin 2> /dev/null`
#~ copy_to_tftproot "$fw_files"

#~ initramfs_files=`cd $prebuiltimagesdir;ls -1 *fw-initrd*.cpio.gz 2> /dev/null`
#~ copy_to_tftproot "$initramfs_files"

echo
if [ -f $tftpcfg ]; then
    echo "$tftpcfg already exists.."

    #Use = instead of == for POSIX and dash shell compliance
    if [ "`cat $tftpcfg | grep server_args | cut -d= -f2 | sed 's/^[ ]*//'`" \
          = "$tftproot" ]; then
        echo "$tftproot already exported for TFTP, skipping.."
    else
        echo "Copying old $tftpcfg to $tftpcfg.old"
        sudo cp $tftpcfg $tftpcfg.old
        check_status
        tftp
    fi
else
    tftp
fi

echo
echo "Restarting tftp server"
sudo /etc/init.d/xinetd stop
check_status
sleep 1
sudo /etc/init.d/xinetd start
check_status
echo "--------------------------------------------------------------------------------"
