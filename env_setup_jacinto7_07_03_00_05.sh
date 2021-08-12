#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=$(pwd)
export jacinto_PATH


PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
#please confirm the below path:
PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
# export the global viable
export PROJECT=Jacinto7_07_03_00_05
export PSDKRA_PATH
export PSDKLA_PATH
export PSDKLA_SDK_URL
export WORK_PATH
export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
