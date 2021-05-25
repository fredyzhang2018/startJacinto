#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=/home/fredy/install/jacinto7

#please confirm the below path:
PSDKRA_PATH=/home/fredy/j7/psdk_rtos_auto_j7_07_00_00_11
PSDKLA_PATH=/home/fredy/j7/ti-processor-sdk-linux-automotive-j7-evm-07_00_01
# export the global viable
export PROJECT=Jacinto7_701
export PSDKRA_PATH
export PSDKLA_PATH
export WORK_PATH
export jacinto_PATH
export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
