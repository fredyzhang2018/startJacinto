#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=/home/fredy/install/jacinto7


#please confirm the below path:
PSDKRA_PATH=/home/fredy/j7/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
PSDKLA_PATH=/home/fredy/j7/ti-processor-sdk-linux-j7-evm-07_03_00_05
# export the global viable
export PROJECT=Jacinto7_07_03_00_05
export PSDKRA_PATH
export PSDKLA_PATH
export WORK_PATH
export jacinto_PATH
export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
