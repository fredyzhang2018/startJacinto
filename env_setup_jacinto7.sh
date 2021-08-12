#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=$(pwd)
export jacinto_PATH



#please confirm the below path:
echo " Welcome Fredy StartJacinto Tool, please help to give your option: "
echo " 1. SDK 0703 for TDA4VM/DRA829 "
echo "    LA: ti-processor-sdk-linux-j7-evm-07_03_00_05  "
echo "    RA: ti-processor-sdk-rtos-j721e-evm-07_03_00_07  "
echo " 2. SDK 0800 for TDA4VM/DRA829  "
echo "    LA: ti-processor-sdk-linux-j7-evm-07_03_00_05  "
echo "    RA: ti-processor-sdk-rtos-j721e-evm-07_03_00_07  "
read -p "plase input your selection: " SELECT 


case  $SELECT in
    1)
        PROJECT=Jacinto7_07_03 && echo "------------- $PROJECT ---------------"
        PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
        PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
        PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
    ;;
    2)
        PROJECT=Jacinto7_08_00
        PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
        PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
        PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
    ;;
    *)
        echo "input is not correct, please try again! Thanks"
    ;;
esac


# export the global viable
export PROJECT=Jacinto7_07_03
export PSDKRA_PATH
export PSDKLA_PATH
export PSDKLA_SDK_URL
export WORK_PATH
export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
