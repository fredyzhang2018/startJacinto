#!/bin/sh
SJ_WORK_PATH=$(pwd)
SJ_PATH_JACINTO=$(pwd)
export SJ_PATH_JACINTO

# Setting SDK variable
SJ_ENABLE_UI=NO
SJ_SOC_TYPE=j721e #Select: am62axx  j721e j721s2 j721s84
SJ_EVM_IP="10.85.130.131"
SJ_LOG_LEVEL=1
SJ_PSDKRA_BRANCH="08_04_00_02"
SJ_PSDKLA_BRANCH="08_04_00_11"
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

if [ $SJ_SOC_TYPE == "j721s2" ];then 
	echo "- update the J721S2"
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/j721s2/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/j721s2/g`
elif [ $SJ_SOC_TYPE == "am62axx" ];then 
	echo "- update the am62axx"
	SJ_PATH_PSDKLA=`echo $Temp_SJ_PATH_PSDKLA | sed s/j7/am62axx/g`
	SJ_PATH_PSDKRA=`echo $Temp_SJ_PATH_PSDKRA | sed s/j721e/am62axx/g`
elif [ $SJ_SOC_TYPE == "j721s84" ];then
	echo "please add"
else
	SJ_PATH_PSDKLA=$Temp_SJ_PATH_PSDKLA
	SJ_PATH_PSDKRA=$Temp_SJ_PATH_PSDKRA
fi 

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
export_variable SJ_LOG_LEVEL
# Main PATH
SJ_PATH_RESOURCE=$SJ_PATH_JACINTO/resource
SJ_PATH_SCRIPTS=$SJ_PATH_JACINTO/scripts
SJ_PATH_DOWNLOAD=$SJ_PATH_JACINTO/downloads
SJ_PATH_TOOLS=$SJ_PATH_JACINTO/tools
SJ_PATH_SDK=$SJ_PATH_JACINTO/sdks
export_variable SJ_PATH_RESOURCE
export_variable SJ_PATH_SCRIPTS
export_variable SJ_PATH_DOWNLOAD
export_variable SJ_PATH_TOOLS
export_variable SJ_PATH_SDK

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
