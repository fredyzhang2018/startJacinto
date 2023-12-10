#!/bin/sh
SJ_WORK_PATH=$(pwd)
SJ_PATH_JACINTO=$(pwd)
export SJ_PATH_JACINTO

sj_usage()
{
	echo "# source env_setup_jacinto.sh - To launch the startJacinto tools"
	echo "# source env_setup_jacinto.sh --list  | -l - To list all the supported SDKs Selections"
	echo "# source env_setup_jacinto.sh --help  | -h - To display this"
	echo "# source env_setup_jacinto.sh --guide | -g - To display help info"
}

sj_check_args()
{
	if [ ! -f /usr/bin/dialog ];then
		sudo apt install dialog
	fi
	valid_args=(--list -l --help -h --guide -g)
	if [ "$1" == "" ]
	then
		return 0
	fi
	for i in "${valid_args[@]}"
	do
		if [ "$1" == "$i" ]
		then
			return 0
		fi
	done
	sj_usage
}
sj_parse_args()
{  
	# clean the 
	unset SJ_SDKS_SELECTION
	echo "[ $(date) ] >>> starting parse args >>>>> \n" > $SJ_PATH_JACINTO/.sj_log
	while read rows
	do 
		# echo $rows; 
		if [ `echo $rows| cut -c 1` == "#" ];then
			echo "- ignore this line: $rows"
		elif [ `echo $rows| cut -c 1-3` == "SDK" ];then
			# echo "- SDK: $rows"
			# echo $rows | awk -F "," '{print $1 $2 $3}'
			SJ_SDKS_SELECTION+=`echo $rows | awk -F "," '{print $1}'`
			SJ_SDKS_SELECTION+=" "
			SJ_SDKS=LA:`echo $rows | awk -F "," '{print $2}'`-RA:`echo $rows | awk -F "," '{print $3}'`
			SJ_SDKS_SELECTION+=$SJ_SDKS
			SJ_SDKS_SELECTION+=" "
		else 
			echo "---"
		fi
		# echo $SJ_SDKS_SELECTION
	done <  $SJ_PATH_JACINTO/.sj_config_sdks
	echo "[ $(date) ] >>>  SDKs : ${SJ_SDKS_SELECTION[@]}"  >> $SJ_PATH_JACINTO/.sj_log
}


sj_guide()
{  
	# clean the 
	unset SJ_SDKS_GUIDE_LIST
	echo "[ $(date) ] >>> starting startJacinto Userguide >>>>> \n" > $SJ_PATH_JACINTO/.sj_log
	while read rows
	do 
		# echo $rows; 
		# echo "- SDK: $rows"
		# echo $rows | awk -F "," '{print $1 $2 $3}'
		SJ_SDKS_GUIDE_LIST+=`echo $rows | awk -F "," '{print $1}'`
		SJ_SDKS_GUIDE_LIST+=" "
		SJ_SDKS_GUIDE_LIST+=`echo $rows | awk -F "," '{print $2}'`
		SJ_SDKS_GUIDE_LIST+=" "
		# echo $SJ_SDKS_SELECTION
	done <  $SJ_PATH_JACINTO/.sj_config_guide
	echo "[ $(date) ] >>>  startJacinto Userguide : ${SJ_SDKS_GUIDE_LIST[@]}"  >> $SJ_PATH_JACINTO/.sj_log

	while [ 1 ]
	do
		sj_guide_select=`dialog --title 'StartJacinto Tools' \
			--colors \
			--colors \
			--ascii-lines \
			--output-fd 1 \
			--menu  "Select your SDK Version:"  \
			300 100 20 ${SJ_SDKS_GUIDE_LIST[@]}`
		echo "[ $(date) ] >>>  startJacinto sj_guide_select : $sj_guide_select $?"  >> $SJ_PATH_JACINTO/.sj_log
		if [ $sj_guide_select = "0-exit" ]; then 
			dialog --msgbox "exit the guide" 10 30
			break;
		else 
			echo "[ $(date) ] >>> sj_guide_select : print $sj_guide_select info"  >> $SJ_PATH_JACINTO/.sj_log
			make $sj_guide_select > $SJ_PATH_JACINTO/.sj_info_guide
			dialog --textbox $SJ_PATH_JACINTO/.sj_info_temp 20 120 
			echo "[ $(date) ] >>>  test : $sj_guide_select $?"  >> $SJ_PATH_JACINTO/.sj_log
		fi		
		# if [ $sj_guide_select = "exit" ]; then 
		# 	dialog --msgbox "exit the guide" 10 30
		# 	break;
		# fi
	done
}

# Export the Variable
# $1 Variable
export_variable() 
{
	export $1
	eval var=\${$1}
	echo "[ $(date) ] >>> $1 = $var  "  >> $SJ_PATH_JACINTO/.sj_log
	# echo "[ $(date) ] >>> $1 = $var  "
}


sj_sdk_setting() 
{  
	# SDKs 
	unset SJ_SDKS_SELECTION
	echo "[ $(date) ] >>>  SDK selection: $1"
	
	while read rows
	do 
		# echo $rows;
		if [ `echo $rows| cut -c 1` == "#" ];then
			echo "- $rows" 
		elif [ `echo $rows | awk -F "," '{print $1}'` == "$1" ];then
			local Var1=`echo $rows | awk -F "," '{print $1}'` # Project Name
			local Var2=`echo $rows | awk -F "," '{print $2}'` # LA
			local Var3=`echo $rows | awk -F "," '{print $3}'` # RA
			# echo "- ignore this line: $rows"
			echo "[ $(date) ] >>> Array :  $Var1 $Var2 $Var3"  >> $SJ_PATH_JACINTO/.sj_log
			echo "[ $(date) ] >>> Array :  $Var1 $Var2 $Var3" 
			SJ_PROJECT=$Var1
			SJ_PSDKLA_BRANCH=$Var2 
			SJ_PSDKRA_BRANCH=$Var3 
			SJ_SOC_TYPE=`echo $Var1 | awk -F "-" '{print $3}'`
			echo "[ $(date) ] >>> SOC TYPE: $SJ_SOC_TYPE"
			# For AM62axx using xx.xx.xx.xx tda4x using xx_xx_xx_xx, pls install the am62x as the xx_xx_xx_xx
			psdkra_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
			if [ $(($psdkra_ver)) -gt $(("9000000")) ];then
				# echo "version > $(($psdkra_ver))  vs $(("9000000"))"
				Temp_SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-adas-j7-evm-$Var2
			else
				# echo "version <= $(($psdkra_ver)) vs $(("9000000"))"
				Temp_SJ_PATH_PSDKLA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-linux-j7-evm-$Var2
			fi
			
			
			if [ $SJ_PROJECT == "SDK-WORKAREA" ];then
				Temp_SJ_PATH_PSDKRA=/ti/j7/workarea 
			else
				Temp_SJ_PATH_PSDKRA=$SJ_PATH_JACINTO/sdks/ti-processor-sdk-rtos-j721e-evm-$Var3
			fi
		 elif [ `echo $rows| awk -F "=" '{ print $1 }'` == "SJ_SOC_TYPE" ];then
			# echo "- SDK: $rows"
			local Var1=`echo $rows | awk -F "=" '{print $1}'` # SJ_SOC_TYPE
			local Var2=`echo $rows | awk -F "=" '{print $2}'` # Value 
			# echo "-------------$Var1 $Var2"
			SJ_SOC_TYPE=$Var2 # SJ_SOC_TYPE=J721
		elif [ `echo $rows| awk -F "=" '{ print $1 }'` == "SJ_EVM_IP" ];then
			# echo "- SDK: $rows"
			local Var1=`echo $rows | awk -F "=" '{print $1}'` # SJ_EVM_IP
			local Var2=`echo $rows | awk -F "=" '{print $2}'` # Value 
			# echo "-------------$Var1 $Var2"
			SJ_EVM_IP=$Var2 # SJ_SOC_TYPE=J721
		elif [ `echo $rows| awk -F "=" '{ print $1 }'` == "SJ_SERVER_IP" ];then
			# echo "- SDK: $rows"
			local Var1=`echo $rows | awk -F "=" '{print $1}'` # SJ_SERVER_IP
			local Var2=`echo $rows | awk -F "=" '{print $2}'` # Value 
			# echo "-------------$Var1 $Var2"
			SJ_SERVER_IP=$Var2 # SJ_SOC_TYPE=J721
		elif [ `echo $rows| awk -F "=" '{ print $1 }'` == "SJ_LOG_LEVEL" ];then
			# echo "- SDK: $rows"
			local Var1=`echo $rows | awk -F "=" '{print $1}'` # SJ_LOG_LEVEL
			local Var2=`echo $rows | awk -F "=" '{print $2}'` # Value 
			# echo "-------------$Var1 $Var2"
			SJ_LOG_LEVEL=$Var2 # SJ_SOC_TYPE=J721
		elif [ `echo $rows| awk -F "=" '{ print $1 }'` == "SJ_YOCTO_CONFIG_FILE" ];then
			# echo "- SDK: $rows"
			local Var1=`echo $rows | awk -F "=" '{print $1}'` # SJ_YOCTO_CONFIG_FILE
			local Var2=`echo $rows | awk -F "=" '{print $2}'` # Value 
			# echo "-------------$Var1 $Var2"
			SJ_YOCTO_CONFIG_FILE=$Var2 # SJ_YOCTO_CONFIG_FILE=? 
		# else 
		# 	echo "---"
		fi
		# echo $SJ_SDKS_SELECTION
	done <  $SJ_PATH_JACINTO/.sj_config_sdks

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

	SJ_ENABLE_UI=YES
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
	# update env setting
	sed -i "/^SJ_PSDKRA_BRANCH=/c SJ_PSDKRA_BRANCH=\"$SJ_PSDKRA_BRANCH\""  $SJ_PATH_JACINTO/env_setup_jaicinto.sh
	sed -i "/^SJ_PSDKLA_BRANCH=/c SJ_PSDKLA_BRANCH=\"$SJ_PSDKLA_BRANCH\""  $SJ_PATH_JACINTO/env_setup_jaicinto.sh
	sed -i "/^SJ_SOC_TYPE=/c SJ_SOC_TYPE=$SJ_SOC_TYPE"                 $SJ_PATH_JACINTO/env_setup_jaicinto.sh
	
	echo "Yocto ENV Setting : $SJ_YOCTO_CONFIG_FILE"

}

sj_launch_ui()
{
	# Select your SDK
	sj_selected_sdk=`dialog --title 'StartJacinto Tools' \
		--colors \
		--colors \
		--ascii-lines \
		--output-fd 1 \
		--menu  "Select your SDK Version:"  \
		300 100 20 ${SJ_SDKS_SELECTION[@]}`
	echo "[ $(date) ] >>> Selected SDK: $sj_selected_sdk" >> $SJ_PATH_JACINTO/.sj_log
	sj_sdk_setting $sj_selected_sdk
	echo "############################################################################################"
    echo "#                                                                                          #"
    echo "#                       starting $sj_selected_sdk , Happy Debugging                  #"
    echo "#                                                                                          #"
    echo "############################################################################################"
}

sj_check_args $1
sj_parse_args
case $1 in
	"--list" | "-l")
		cat $SJ_PATH_JACINTO/.sj_config_sdks
		;;
	"--help" | "-h")
		sj_usage
		;;
	"--guide" | "-g")
		sj_guide
		;;
	"")
		sj_launch_ui
		export PS1="\[\e[32;1m\][$SJ_PROJECT]\[\e[0m\]:\w> "
		;;
esac
#---------------------------------------------------------------------------
