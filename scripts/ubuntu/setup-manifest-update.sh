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
        cd $DOWNLOAD_DIR/${DIR} && git branch -r | grep -v '\->' | grep "fredy*"  | while read remote; do echo "$remote"; git branch -D "$remote"; git push fredy --delete "$remote"; done
        cd $DOWNLOAD_DIR/${DIR} && git fetch --all && git pull --all
        cd $DOWNLOAD_DIR/${DIR} && git push -u fredy --all
        cd $DOWNLOAD_DIR/${DIR} && git push -u fredy --tags
        echo "----------------${DIR} updating starting done!!!--------------------------- "
    echo ""
}


echo "This sciptes will update the remote repo to local repo" 
DOWNLOAD_DIR=/home/fredy/test
LOCAL_URL=ssh://git@10.85.130.233:7999
for i in   1 2 3 4 5 6 7 8 9 10 11 # 1 2 3 4 5 6 7 8 9 10 11
do
    case $i in
        1)
            DIR_LIST="repo_manifests vision_apps"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=processor-sdk-vision
            LOCAL_URL_PROJECT=com 
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        2)
            DIR_LIST="vision_apps psdk_rtos_auto tiovx tiovx_dev test_data imaging j7_ad_algos gateway-demos perception \
                        j7_c_models remote_device video_codec ivision mcusw concerto csirx-lld  csitx-lld vhwa ethfw"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=processor-sdk-vision
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        3)
            DIR_LIST="srv"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=srv
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        4)
            DIR_LIST="ti-img-encode-decode"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=j7mmpub
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        5)
            DIR_LIST="pdk common-csl-ip serdes_diag pm pmic_lld enet-lld sa-lld pdk_docs"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=processor-sdk
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        6)
            DIR_LIST="rm_pm_hal"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=sysfw
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        7)
            DIR_LIST="lwip"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=git
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=https://git.savannah.gnu.org
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        8)
            DIR_LIST="lwip-contrib"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=git/lwip
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=https://git.savannah.gnu.org
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        9)
            DIR_LIST="FreeRTOS-Kernel Lab-Project-FreeRTOS-POSIX"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=FreeRTOS
            LOCAL_URL_PROJECT=psdkra
            REMOTE_URL=https://github.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        10)
            DIR_LIST="psdkqa qnx710_stage k3conf"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=tqp
            LOCAL_URL_PROJECT=psdkqa
            REMOTE_URL=ssh://git@bitbucket.itg.ti.com
            for DIR in $DIR_LIST
            do
                download_and_update_local_repo $DOWNLOAD_DIR $DIR $REMOTE_URL $REMOTE_URL_PROJECT $LOCAL_URL  $LOCAL_URL_PROJECT
            done
        ;;
        11)
            DIR_LIST="bsp_ti-j721e-am752x-evm_br-mainline_be-710"
            #DIR_LIST=""
            REMOTE_URL_PROJECT=tqi
            LOCAL_URL_PROJECT=psdkqa
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