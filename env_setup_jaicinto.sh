#!/bin/sh
SJ_WORK_PATH=$(pwd)
SJ_PATH_JACINTO=$(pwd)
export SJ_PATH_JACINTO

# Setting SDK variable
SJ_ENABLE_UI=NO
SJ_SOC_TYPE=j721s2
SJ_EVM_IP="10.85.130.131"
SJ_LOG_LEVEL=1
SJ_PSDKRA_BRANCH="09_01_00_06"
SJ_PSDKLA_BRANCH="09_01_00_06"
SJ_YOCTO_CONFIG_FILE=processor-sdk-linux-08_04_00.txt
SJ_PROJECT=$SJ_SOC_TYPE-$SJ_PSDKLA_BRANCH-$SJ_PSDKRA_BRANCH

# Export the Variable
# $1 Variable
export_variable() 
{
	export $1
	eval var=\${$1}
	echo "[ $(date) ] >>> $1 = $var  "  >> $SJ_PATH_JACINTO/.sj_log
	# echo "[ $(date) ] >>> $1 = $var  "
}

echo "[ $(date) ] >>> starting set parameter ... \n" > $SJ_PATH_JACINTO/.sj_log
export_variable SJ_SOC_TYPE
# AUTO SETTING
Temp_SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-j7-evm-$SJ_PSDKLA_BRANCH
Temp_SJ_PATH_PSDKRA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-rtos-j721e-evm-$SJ_PSDKRA_BRANCH

psdkra_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
if [ $(($psdkra_ver)) -gt $(("9000000")) ];then
	# echo "version > $(($psdkra_ver))  vs $(("9000000"))"
	Temp_SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-adas-j7-evm-$SJ_PSDKLA_BRANCH
	# echo "version <= $(($psdkra_ver)) vs $(("9000000"))"
	Temp_SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-j7-evm-$SJ_PSDKLA_BRANCH
fi

if [ $SJ_SOC_TYPE == "j721s2" ];then 
	echo "- update the J721S2"
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/j721s2/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/j721s2/g`
elif [ $SJ_SOC_TYPE == "am62axx" ];then 
	echo "- update the am62axx"
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/am62axx/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/-j721e-evm-/_am62ax_/g | sed s/ti-processor-sdk-rtos/mcu_plus_sdk/g`
elif [ $SJ_SOC_TYPE == "am62xx" ];then 
	echo "- update the am62xx"
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/am62xx/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/-j721e-evm-/_am62x_/g | sed s/ti-processor-sdk-rtos/mcu_plus_sdk/g`
elif [ $SJ_SOC_TYPE == "j784s4" ];then
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/j784s4/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/j784s4/g`
elif [ $SJ_SOC_TYPE == "j721e" ];then
	psdkra_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
	if [ $(($psdkra_ver)) -gt $(("9000000")) ];then
		SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/j721e/g`
		SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/j721e/g`
	else
		SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/j7/g`
		SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/j721e/g`
	fi

else
	SJ_PATH_PSDKLA=$Temp_SJ_PATH_PSDKLA
	SJ_PATH_PSDKRA=$Temp_SJ_PATH_PSDKRA
fi 
echo $SJ_PATH_PSDKLA
echo $SJ_PATH_PSDKRA

export_variable SJ_ENABLE_UI
export_variable SJ_PROJECT
# PSDKLA
export_variable SJ_PSDKLA_BRANCH
export_variable SJ_PATH_PSDKLA
export_variable SJ_YOCTO_CONFIG_FILE
# PSDKRA
export_variable SJ_PSDKRA_BRANCH
export_variable SJ_PATH_PSDKRA

export_variable SJ_WORK_PATH
export_variable SJ_PATH_JACINTO
export_variable SJ_SOC_TYPE
export_variable SJ_EVM_IP
export_variable SJ_SERVER_IP
export_variable SJ_LOG_LEVEL

# Main PATH
SJ_PATH_RESOURCE=$SJ_PATH_JACINTO/resource
SJ_PATH_SCRIPTS=$SJ_PATH_JACINTO/scripts
SJ_PATH_DOWNLOAD=$SJ_PATH_JACINTO/downloads
SJ_PATH_TOOLS=$SJ_PATH_JACINTO/tools
SJ_PATH_SDK=$SJ_PATH_JACINTO/sdks
SJ_PATH_SDK1=$SJ_PATH_JACINTO/sdks1
export_variable SJ_PATH_RESOURCE
export_variable SJ_PATH_SCRIPTS
export_variable SJ_PATH_DOWNLOAD
export_variable SJ_PATH_TOOLS
export_variable SJ_PATH_SDK
export_variable SJ_PATH_SDK1
# New path for SDK version. this is used for different sdks's selection. 
SJ_VER_SDK=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 1-2`
export_variable SJ_VER_SDK

echo "Yocto ENV Setting : $SJ_YOCTO_CONFIG_FILE"
echo "############################################################################################"
echo "#                                                                                          #"
echo "#                       starting $sj_selected_sdk , Happy Debugging -- No UI               #"
echo "#                                                                                          #"
echo "############################################################################################"
echo "Project : $SJ_PROJECT Start Debugging..."
export PS1="\[\e[32;1m\][$SJ_PROJECT]\[\e[0m\]:\w> "
echo ""
#---------------------------------------------------------------------------
