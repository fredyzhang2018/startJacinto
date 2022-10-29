#!/bin/sh
#############################################################################################
# This script is using for running the command on remote machine.                           #
#     You should make sure you can login the remote shell without password.     
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-16                                                                      # 
##############################################################################################

# test purpose
# FIRST_LINE=`cat ./remote_command.sh  | grep -n remotessh | awk -F":" '{ print $1 }' | sed -n "1p"`
# LAST_LINE=`cat ./remote_command.sh  | grep -n remotessh | awk -F":" '{ print $1 }' | sed -n "2p"`
# cd /opt/vision_apps 
# source ./vison_apps_init.sh
# # ./run_app_tidl.sh >> /dev/null 
# ./run_app_dof.sh
#---------------------------------------------------------------------------


# scp fredy@10.85.130.60:/home/fredy/startJacinto/sdks/ti-processor-sdk-rtos-j721e-evm-08_02_00_05/vision_apps/out/J7/A72/LINUX/release/vx_app_tidl2.out ./

# conformance testing 
cd /opt/vision_apps  && source ./vision_apps_init.sh
echo "./vx_app_conformance.out --filter=tivxHwaDisplayM2M.tivxHwaDisplayM2Mtest"
./vx_app_conformance.out --filter=tivxHwaDisplayM2M.tivxHwaDisplayM2Mtest
# ./vx_app_conformance.out --filter=tivxHwaDisplay.ZeroBufferCopyMode
# ./vx_app_conformance.out --filter=tivxHwaCsitxCsirx.CsitxCsirxloopback  // test works

# Reading Dia ID
# echo "-----------------DIE ID as below----------------------------"
# echo `devmem2 0x43000020 w | tail -n1`
# echo `devmem2 0x43000024 w | tail -n1`
# echo `devmem2 0x43000028 w | tail -n1`
# echo `devmem2 0x4300002c w | tail -n1`

# # How to check if reboot happened because of Thermal Shutdown (TSHUT).
# # CTRLMMR_WKUP_RESET_SRC_STAT Register For Cold boot, the value of this register is 0x0 (1st
# # fresh boot). In the event of TSHUT, then the next boot in Linux:
# #  So bit24 is set corresponding to THERMAL_RST indicating the reset due to TSHUT.
# echo "----------------CTRLMMR_WKUP_RESET_SRC_STAT bit24 TSHUT-----------"
# devmem2 0x43000050 w | tail -n1

# # Shell script to get the status of the top power consuming power domains
# echo "----------------the status of the top power consuming power domains-----------"
# echo " Device List : https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721e/devices.html"
# k3conf dump device > devdump
# cat devdump | grep -E ' 202 | 203 | 124 | 140 | 4 | 16 | 140 | 141 | 243 | 244 | 48 | 290 | 144 | 153 | 249 '

# # check the device status of jacinto7
# echo "----------------check the device status-----------"
# echo " Device List : https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721e/devices.html"
# k3conf dump device 142
# k3conf dump device 143
# k3conf dump device 239

# Dynamic Frequency Scaling (DFS) refer: https://www.ti.com/lit/an/spracz5/spracz5.pdf

#To set the C7x clock frequency to 500 MHz, device ID for C7x = 16 and CLK_ID = 1 use the following command on the Linux command line:
# k3conf set clock 16 1 500000000
# To reduce the R5F clock frequency from 1GHZ to 500 MHz, device ID for MAIN_R5FSS0_CORE0 = 245 and CLK_ID = 0 use the following command on the Linux command line:
# k3conf set clock 245 0 500000000
