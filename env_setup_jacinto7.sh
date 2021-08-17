#!/bin/sh
WORK_PATH=$(pwd)
jacinto_PATH=$(pwd)
export jacinto_PATH



#please confirm the below path:
echo "############################################################################################"
echo "#                                                                                          #"
echo "#                       Welcome to StartJacinto Tool                                 #"
echo "#                                                                                          #"
echo "############################################################################################"
echo "please help to give your option:"  
echo " 1. SDK 0800 for TDA4VM/DRA829 "
echo "    LA: ti-processor-sdk-linux-j7-evm-08_00_00_08  "
echo "    RA: ti-processor-sdk-rtos-j721e-evm-08_00_00_12  "
echo " 2. SDK 0703 for TDA4VM/DRA829  "
echo "    LA: ti-processor-sdk-linux-j7-evm-07_03_00_05  "
echo "    RA: ti-processor-sdk-rtos-j721e-evm-07_03_00_07  "
read -p "plase input your selection: " SELECT 
echo "--------------------------------------------------------------------------------------------"

case  $SELECT in
    1)
        PROJECT=Jacinto7_08_00
        PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-08_00_00_12
        PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-08_00_00_08
        PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/08_00_00_08/exports/ti-processor-sdk-linux-j7-evm-08_00_00_08-Linux-x86-Install.bin
        YOCTO_CONFIG_FILE=processor-sdk-linux-08_00_00.txt
        # PSDKRA 
	    PSDKRA_PG_NAME=ti-processor-sdk-rtos-j721e-evm-08_00_00_12
	    PSDKRA_INSTALL_PACKAGES_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_00_00_12/exports/ti-processor-sdk-rtos-j721e-evm-08_00_00_12.tar.gz
	    PSDKRA_TI_DATA_DOWNLOAD_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_00_00_12/exports/psdk_rtos_ti_data_set_08_00_00.tar.gz
	    PSDKRA_TI_DATA_PTK_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
	    PSDKRA_ADD_ON_LINK=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v8.00.00/ti-processor-sdk-rtos-j721e-evm-08_00_00_12-addon-linux-x64-installer.run
    ;;
    2)
        PROJECT=Jacinto7_07_03
        PSDKRA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
        PSDKLA_PATH=$jacinto_PATH/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
        PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
        YOCTO_CONFIG_FILE=processor-sdk-linux-07_03_00.txt
        # PSDKRA 
	    PSDKRA_PG_NAME=ti-processor-sdk-rtos-j721e-evm-07_03_00_07
	    PSDKRA_INSTALL_PACKAGES_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/ti-processor-sdk-rtos-j721e-evm-07_03_00_07.tar.gz
	    PSDKRA_TI_DATA_DOWNLOAD_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/psdk_rtos_ti_data_set_07_03_00.tar.gz
	    PSDKRA_TI_DATA_PTK_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
	    PSDKRA_ADD_ON_LINK=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v7.03.00/ti-processor-sdk-rtos-j721e-evm-07_03_00_07-addon-linux-x64-installer.run    
    ;;
    *)
        echo "input is not correct, please try again! Thanks"
    ;;
esac


echo "############################################################################################"
echo "#                                                                                          #"
echo "#                       starting $PROJECT , Happy Debugging                          #"
echo "#                                                                                          #"
echo "############################################################################################"
# export the global viable
export PROJECT
export PSDKRA_PATH
export PSDKLA_PATH
#PSDKLA
export PSDKLA_SDK_URL
export YOCTO_CONFIG_FILE
#PSDKRA
export PSDKRA_PG_NAME
export PSDKRA_INSTALL_PACKAGES_LINK
export PSDKRA_TI_DATA_DOWNLOAD_LINK
export PSDKRA_ADD_ON_LINK

export WORK_PATH
export PS1="\[\e[32;1m\][$PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
