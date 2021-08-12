#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=$(pwd)
export jacinto_PATH
#please confirm the below path:
PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
# export the global viable
export PROJECT=Jacinto7_07_03_00_05
export PSDKRA_PATH
export PSDKLA_PATH
export WORK_PATH

export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
