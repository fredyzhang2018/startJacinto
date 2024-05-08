#!/bin/sh
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com															#				
# @date   ：2024-03-16                                                                      # 
# @update : fredy  V2                                                                       # 
##############################################################################################

# including common tools. 
. $SJ_PATH_JACINTO/scripts/ubuntu/common_ubuntu.sh

# LOG _LEVEL:  0 (error), 1 (info) , 2(debug) , 3 (debug_plus)
LOG_LEVEL=3

# minicomcfg files
minicomcfg=${HOME}/.minirc.dfl

cat << EOM
--------------------------------------------------------------------------------"
This step will set up minicom (serial communication application) for
SDK development


For boards that contain a USB-to-Serial converter on the board such as:
	* J721S2  EVM 4 main port and 2 uart port. 
	* J721E EVM 4 main port and 2 uart port. 

--------------------------------------------------------------------------------
EOM

portdefault=/dev/ttyUSB0

sh_log info  "------------------------config the port -------------------------------------"
sh_log info "Which serial port do you want to use with minicom?"

ls -l /dev/ttyUSB*

read -p "[ $portdefault ] " port

if [ ! -n "$port" ]; then
    port=$portdefault
fi

if [ -f $minicomcfg ]; then
    cp $minicomcfg $minicomcfg.old
    sh_log info ""
    sh_log info "Copied existing $minicomcfg to $minicomcfg.old"
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

sh_log info 
sh_log warning "pls notice the port config for k3 host tools "
sh_log file "k3bootswitch" "$HOME/.config/k3bootswitch.conf"
sh_log file "Configuration saved to You can change it further from inside" "$PUR $minicomcfg"
sh_log file "Configuration common" "$PUR $SJ_PATH_JACINTO/scripts/ubuntu/common_ubuntu.sh."
sh_log file "shell scripts running" "$PUR $basename/$0"
sh_log info "minicom, see the Software Development Guide for more information."
sh_log info "--------------------------------------------------------------------------------"
