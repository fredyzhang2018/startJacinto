#!/bin/sh
SJ_WORK_PATH=$(pwd)
SJ_PATH_JACINTO=$(pwd)
export SJ_PATH_JACINTO

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
read -p "plase input your selection: " SJ_SELECT 
echo "--------------------------------------------------------------------------------------------"

case  $SJ_SELECT in
    1)
        SJ_PROJECT=Jacinto7_08_00
        SJ_PATH_PSDKRA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-rtos-j721e-evm-08_00_00_12
        SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-j7-evm-08_00_00_08
        SJ_PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/08_00_00_08/exports/ti-processor-sdk-linux-j7-evm-08_00_00_08-Linux-x86-Install.bin
        SJ_YOCTO_CONFIG_FILE=processor-sdk-linux-08_00_00.txt
        # PSDKRA 
	    SJ_PSDKRA_PG_NAME=ti-processor-sdk-rtos-j721e-evm-08_00_00_12
	    SJ_PSDKRA_INSTALL_PACKAGES_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_00_00_12/exports/ti-processor-sdk-rtos-j721e-evm-08_00_00_12.tar.gz
	    SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_00_00_12/exports/psdk_rtos_ti_data_set_08_00_00.tar.gz
	    SJ_PSDKRA_TI_DATA_PTK_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
	    SJ_PSDKRA_ADD_ON_LINK=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v8.00.00/ti-processor-sdk-rtos-j721e-evm-08_00_00_12-addon-linux-x64-installer.run
    ;;
    2)
        SJ_PROJECT=Jacinto7_07_03
        SJ_PATH_PSDKRA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-rtos-j721e-evm-07_03_00_07 
        SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-j7-evm-07_03_00_05
        SJ_PSDKLA_SDK_URL=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
        SJ_YOCTO_CONFIG_FILE=processor-sdk-linux-07_03_00.txt
        # PSDKRA 
	    SJ_PSDKRA_PG_NAME=ti-processor-sdk-rtos-j721e-evm-07_03_00_07
	    SJ_PSDKRA_INSTALL_PACKAGES_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/ti-processor-sdk-rtos-j721e-evm-07_03_00_07.tar.gz
	    SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/psdk_rtos_ti_data_set_07_03_00.tar.gz
	    SJ_PSDKRA_TI_DATA_PTK_LINK=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
	    SJ_PSDKRA_ADD_ON_LINK=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v7.03.00/ti-processor-sdk-rtos-j721e-evm-07_03_00_07-addon-linux-x64-installer.run    
    ;;
    *)
        echo "input is not correct, please try again! Thanks"
    ;;
esac


echo "############################################################################################"
echo "#                                                                                          #"
echo "#                       starting $SJ_PROJECT , Happy Debugging                          #"
echo "#                                                                                          #"
echo "############################################################################################"
# export the global viable
export SJ_PROJECT
export SJ_PATH_PSDKRA
export SJ_PATH_PSDKLA
#PSDKLA
export SJ_PSDKLA_SDK_URL
export SJ_YOCTO_CONFIG_FILE
#PSDKRA
export SJ_PSDKRA_PG_NAME
export SJ_PSDKRA_INSTALL_PACKAGES_LINK
export SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK
export SJ_PSDKRA_ADD_ON_LINK

export SJ_WORK_PATH
export PS1="\[\e[32;1m\][$SJ_PROJECT]\[\e[0m\]:\w> "
#---------------------------------------------------------------------------
