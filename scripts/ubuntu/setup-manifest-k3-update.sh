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



####################################################################
# DOWNLOAD_DIR=
# DIR="repo_manifests"
# REMOTE_URL=
# LOCAL_URL=
# LOCAL_URL_PROJECT=
# REMOTE_URL_PROJECT=
####################################################################
download_and_update_local_repo() {
    DOWNLOAD_DIR=$1
    DIR=$2
    REMOTE_URL=$3
    REMOTE_URL_PROJECT=$4
    LOCAL_URL=$5
    LOCAL_URL_PROJECT=$6
    echo ""
    echo "#  Download $DIR to  $DOWNLOAD_DIR  " 
    echo "#  update repo from $REMOTE_URL/$REMOTE_URL_PROJECT/$DIR.git to  $LOCAL_URL/$LOCAL_URL_PROJECT/$DIR.git  "
    echo "----------------${DIR} updating starting--------------------------------- "
        if [ ! -d "$DOWNLOAD_DIR/${DIR}" ]; then
            cd $DOWNLOAD_DIR && git clone $REMOTE_URL/$REMOTE_URL_PROJECT/${DIR}.git;
            cd $DOWNLOAD_DIR/${DIR} && git remote add fredy $LOCAL_URL/$LOCAL_URL_PROJECT/${DIR}.git 
        else 
            echo "----------------already installed"
            cd $DOWNLOAD_DIR/${DIR} && git pull origin
        fi
        cd $DOWNLOAD_DIR/${DIR} && git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
        cd $DOWNLOAD_DIR/${DIR} && git fetch --all && git pull --all
        cd $DOWNLOAD_DIR/${DIR} && git push -u fredy --all
        cd $DOWNLOAD_DIR/${DIR} && git push -u fredy --tags
        echo "----------------${DIR} updating starting done!!!--------------------------- "
    echo ""
}


echo "This sciptes will update the remote repo to local repo" 
DOWNLOAD_DIR=/home/fredy/test
LOCAL_URL=ssh://git@10.85.130.233:7999
for i in   1 2 3 # 1 2 3 4 5 6 7 8 9 10 11
do
    case $i in
        1)
            DIR_LIST="utilities"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=lcpd-priv-sdk
            LOCAL_URL_PROJECT=psdkla
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        2)
            DIR_LIST="ti-u-boot  k3-image-gen arm-trusted-firmware optee_os ti-linux-kernel ti-jailhouse ti-linux-firmware"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=lcpdpub
            LOCAL_URL_PROJECT=psdkla
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        3)
            DIR_LIST="buildroot ks3_lnx_apps busybox"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=ks3prelinux
            LOCAL_URL_PROJECT=psdkla
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        *)
            echo "no option, please check"
        ;;
    esac
    
done 



##-------SRV
#DOWNLOAD_DIR=/home/fredy/test
#DIR_LIST="srv"
#DIR_LIST=""
#REMOTE_URL=ssh://git@bitbucket.itg.ti.com
#REMOTE_URL_PROJECT=srv
#LOCAL_URL=ssh://git@10.85.130.233:7999
#LOCAL_URL_PROJECT=psdkra

#download_and_update_local_repo $DOWNLOAD_DIR $DIR_LIST $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
###############################################################done!!!!!!!!!!!!!!!


#--------------------------------------------------------------------------------------done!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!