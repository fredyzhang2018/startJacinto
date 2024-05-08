#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-26                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p --dataset -d )

# LOG _LEVEL:  0 (error), 1 (info) , 2(debug) , 3 (debug_plus)
LOG_LEVEL=1

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/downloads/
VERSION="08_01_00_11"
SETUP_YES_NO="no"
CPU_NUM=`nproc`
DATASET_YES_NO="no"

. $SJ_PATH_JACINTO/scripts/ubuntu/common_ubuntu.sh


# --- usage introduction. 
usage()
{
echo " Usage: $0 <options>
	# $0 - To print help infomation
	# $0 --help      |  -h   : print help infomation.
	Mandatory options:
	--path    | -p           : install PATH

	Optional options:
	--verbose | -v           : verbose print output.
	--version | -s           : set the version (Default : $VERSION )
	--install | -i           : default no, set yes
	--dataset | -d           : default no, set yes

More details , please visit : xxx
"
}

# update args value
# $1 : $*
update_args_value()
{
	# loop args and set the variable
	args_list=$* 
	sh_log debug_plus "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		# sh_log debug " args : $args"
		case $args in
			"--help" | "-h")
				usage
				;;
			"--verbose" | "-v")
				LOG_LEVEL=3
				sh_log debug_plus "--- -v LOG_LEVEL: $LOG_LEVEL"
				;;
			"--version" | "-s")
				sh_get_arg_value VERSION $# $args $args_list
				sh_log debug_plus "--- -s VERSION: $VERSION"
				;;
			"--install" | "-i")
				sh_get_arg_value SETUP_YES_NO $# $args $args_list
				sh_log debug_plus "--- -i SETUP_YES_NO: $SETUP_YES_NO"
					;;
			"--path" | "-p")
				sh_get_arg_value APP_INSTALL_PATH $# $args $args_list
				sh_log debug_plus "--- -p APP_INSTALL_PATH: $APP_INSTALL_PATH"
				;;
			"--dataset" | "-d")
				sh_get_arg_value DATASET_YES_NO $# $args $args_list
				sh_log debug_plus "--- -p DATASET_YES_NO: $DATASET_YES_NO"
				;;
				
			"*")
				sh_log error "option is not correct, please check!!!"
				;;
		esac
	done
}
# --- parse arguments
parse_args()
{  
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	# check the KEYWRITER VERSION NAME and PDK PATH. 
#   if [ $APP_INSTALL_PATH == "" ];then
#     echo "- please set the INSTALL_PATH"
#     exit 1
#   else 
#     if [ ! -d $APP_INSTALL_PATH ];then
#       echo "- the path is not exist!"
#       exit 1
#     fi
#   fi
}
# --- run application
# $1 : number of args (scripts)
launch() 
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	local num_args=$1
	if [ $num_args == 0 ]
	then
		usage
	else 
		sh_log debug_plus "${FUNCNAME[0]}: args --- $SETUP_YES_NO" 
		if [ $SETUP_YES_NO == "yes" ];then
			setup_release_app
			# setup_src_app
			# echo "test"
			# update_packge_to_target_dictionary
		else
			sh_log debug_plus "${FUNCNAME[0]}: please use -i yes to setup" 
		fi
		sh_log debug_plus "${FUNCNAME[0]}: args ---DATASET_YES_NO  $DATASET_YES_NO" 
		if [ $DATASET_YES_NO == "yes" ];then
			setup_dataset_app
		else
			sh_log debug_plus "${FUNCNAME[0]}: please use -d yes to install the dataset" 
		fi

	fi
}

setup_release_app()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. download the package: $APP_DOWNLOAD_URL" 
	if [ $SJ_SOC_TYPE == "j721e" ];then
		local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	elif [ $SJ_SOC_TYPE == "am62xx" ];then
		local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	else 
		local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8 ` #TODO please check 
	fi
	sh_log debug_plus "---------------------- $Pkg_name"

	if [ $SJ_SOC_TYPE == "am62xx" ];then
		local Pkg_Dir=`echo $Pkg_name| cut -d - -f 1`
	elif [ $SJ_SOC_TYPE == "am62axx" ];then
		local Pkg_Dir=`echo $Pkg_name| cut -d - -f 1`
	else 
		local Pkg_Dir=`echo $Pkg_name| cut -d . -f 1`
	fi
	sh_log debug_plus "- Pkg_name=$Pkg_name Pkg_Dir=$Pkg_Dir"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/$Pkg_name ]; then
			# echo "- $REPO_INSTALL_PATH/$Pkg_name "
			# download the URL : package
			if [ $SJ_SOC_TYPE == "am62xx" ];then
				cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL;
			elif [ $SJ_SOC_TYPE == "am62axx" ];then
				cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL;
			else 
				cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL;
				# download the URL1 : data set.
				cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL1;
				# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
			fi
		else 
			sh_log debug_plus "- download the sdk."
		fi
	else 
		sh_log debug_plus "- Already setup. please continuing ---"
	fi
	sh_log debug "2. install the sdk. " 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		if [ ! -d $APP_INSTALL_PATH/$Pkg_Dir ];then
			sh_log debug_plus "- setup the :$APP_INSTALL_PATH  "
			sh_log debug_plus "- $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH/../ "
			sh_log debug_plus "cd $REPO_INSTALL_PATH && tar -zxvf $Pkg_name.tar.gz -C $APP_INSTALL_PATH/../"
			if [ $SJ_SOC_TYPE == "am62xx" ];then
				cd $REPO_INSTALL_PATH && sudo chmod 777 ./$Pkg_name &&  ./$Pkg_name
			elif [ $SJ_SOC_TYPE == "am62axx" ];then
				cd $REPO_INSTALL_PATH && sudo chmod 777 ./$Pkg_name &&  ./$Pkg_name
			else 
				cd $REPO_INSTALL_PATH && tar -zxvf ./$Pkg_name -C $APP_INSTALL_PATH
			fi
			cd $APP_INSTALL_PATH/$Pkg_Dir
			if [ ! -d $APP_INSTALL_PATH/$Pkg_Dir/.git ] ; then 
				cd $APP_INSTALL_PATH/$Pkg_Dir && git init;
				#TODO too mandy level 
				# ln -s $APP_INSTALL_PATH/../resource/psdkra/gitignore $APP_INSTALL_PATH/$Pkg_Dir/.gitignore ; 
				cp $APP_INSTALL_PATH/../resource/psdkra/gitignore $APP_INSTALL_PATH/$Pkg_Dir/.gitignore ; 
				cd $APP_INSTALL_PATH/$Pkg_Dir && git add -A ;
				cd $APP_INSTALL_PATH/$Pkg_Dir && git commit -m "repo init" ;
			else 
				sh_log debug_plus "Git already setup : $APP_INSTALL_PATH/$Pkg_Dir "; 
			fi
			# cd $cwd && ./expect/expect_psdkla.sh $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH
			# cd $REPO_INSTALL_PATH/ && ./$Pkg_name
		else
			 sh_log debug_plus "- already setup the :$APP_INSTALL_PATH "
		fi  
	else 
		sh_log debug_plus "- file is not exist please check"
	fi
	sh_log debug "3. setup the prebuilt images: $SJ_PATH_PSDKLA  $SJ_PATH_PSDKRA" 
	if [ ! -f $SJ_PATH_PSDKRA/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz ] ; then
			cd $SJ_PATH_PSDKRA && wget $APP_DOWNLOAD_URL2 ; 
	else 
		sh_log debug_plus "prebuild image already setup:$SJ_PATH_PSDKRA/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz "; 
	fi
	sh_log debug "4. the install the filesystem to PSDKRA path. $SJ_PATH_PSDKLA  $SJ_PATH_PSDKRA" 

	if [ $SJ_SOC_TYPE == "j721e" ];then
		if [ ! -f $SJ_PATH_PSDKRA/boot-j7-evm.tar.gz ] ; then
			cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/boot-j7-evm.tar.gz $SJ_PATH_PSDKRA ; 
		else 
			sh_log debug_plus "- boot image already setup:$SJ_PATH_PSDKRA/boot-j7-evm.tar.gz "; 
		fi
	else
		psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
		if [ $(($psdkla_ver)) -gt $(("9000000")) ];then
			if [ ! -f $SJ_PATH_PSDKRA/boot-adas-$SJ_SOC_TYPE-evm.tar.gz ] ; then
				cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/boot-adas-$SJ_SOC_TYPE-evm.tar.gz $SJ_PATH_PSDKRA ; 
			else 
				sh_log debug_plus "- boot image already setup:$SJ_PATH_PSDKRA/boot-adas-$SJ_SOC_TYPE-evm.tar.gz "; 
			fi
		else

			if [ ! -f $SJ_PATH_PSDKRA/boot-$SJ_SOC_TYPE-evm.tar.gz ] ; then
				cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/boot-$SJ_SOC_TYPE-evm.tar.gz $SJ_PATH_PSDKRA ; 
			else 
				sh_log debug_plus "- boot image already setup:$SJ_PATH_PSDKRA/boot-$SJ_SOC_TYPE-evm.tar.gz "; 
			fi
		fi		
	fi

	if [ $SJ_VER_SDK == “09” ];then
		Temp_SDK_NAME="tisdk-default-image"
	else
		Temp_SDK_NAME="tisdk-adas-image"
	fi

	if [ $SJ_SOC_TYPE == "j721e" ];then
		if [ ! -f $SJ_PATH_PSDKRA/$Temp_SDK_NAME-j7-evm.tar.xz ] ; then 
			cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/$Temp_SDK_NAME-j7-evm.tar.xz $SJ_PATH_PSDKRA ; 
		else 
			sh_log debug_plus "- filesystem already setup: $SJ_PATH_PSDKRA/$Temp_SDK_NAME-j7-evm.tar.xz "; 
		fi
	else
		if [ ! -f $SJ_PATH_PSDKRA/$Temp_SDK_NAME-$SJ_SOC_TYPE-evm.tar.xz ] ; then 
			cp $SJ_PATH_PSDKLA/filesystem/$Temp_SDK_NAME-$SJ_SOC_TYPE-evm.tar.xz $SJ_PATH_PSDKRA ; 
		else 
			sh_log debug_plus "- filesystem already setup: $SJ_PATH_PSDKRA/$Temp_SDK_NAME-j7-evm.tar.xz "; 
		fi
	fi
	sh_log debug "5. install dependcy tools " 
	# SDK0900: changed the build scripts. under SDK0900 , used old. 
	psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
	if [ $(($psdkla_ver)) -gt $(("9000000")) ];then
		cd $SJ_PATH_PSDKRA && ./sdk_builder/scripts/setup_psdk_rtos.sh
	else
		cd $SJ_PATH_PSDKRA && ./psdk_rtos/scripts/setup_psdk_rtos.sh
	fi
	sh_log debug "6.  Ready to compiling. " 
	sh_log info "- download the sdk from secure SW: install add on package for run PC demo. "
	sh_log info "- chmod a+x ./$Pkg_Dir-addon-linux-x64-SJ_INSTALLER.run "	
	sh_log info "- ./$Pkg_Dir-addon-linux-x64-SJ_INSTALLER.run "	
	sh_log info "- PSDKRA Ready to use, congrations!  "	
	sh_log debug "7. installed done !!! " 
}

setup_dataset_app()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. download the dataset package" 
	local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	echo " ---------------------- $Pkg_name"
	local Pkg_Dir=`echo $Pkg_name| cut -d . -f 1`
	echo "- $Pkg_name $Pkg_Dir"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz ]; then
			# echo "- $REPO_INSTALL_PATH/$Pkg_name "
			# download the URL1 : data set.
			cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL1;
		else 
			sh_log debug_plus "- download the sdk."
		fi
		if [ ! -f $REPO_INSTALL_PATH/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_$SJ_SOC_TYPE.tar.gz ]; then
			# echo "- $REPO_INSTALL_PATH/$Pkg_name "
			# download the URL1 : data set for special soc.
			cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL3;
		else 
			sh_log debug_plus "- download the sdk."
		fi
	else 
		sh_log debug_plus "- Already setup. please continuing ---"
	fi
	sh_log debug "2. install the dataset. " 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		if [ -d $APP_INSTALL_PATH/$Pkg_Dir ];then
			sh_log debug_plus "2.1 untar the dataset. " 
			if [ -f $REPO_INSTALL_PATH/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz ]; then
				cd $REPO_INSTALL_PATH && tar -zxvf ./psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz;
				cp -v $REPO_INSTALL_PATH//psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`/test_data/*  $SJ_PATH_PSDKRA/tiovx/conformance_tests/test_data/
			fi
			sh_log debug_plus "2.2 untar the dataset. $SJ_SOC_TYPE " 
			if [ -f $REPO_INSTALL_PATH/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_$SJ_SOC_TYPE.tar.gz ]; then
				cd $REPO_INSTALL_PATH && tar -zxvf ./psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_$SJ_SOC_TYPE.tar.gz;
			fi
			cp -rv $REPO_INSTALL_PATH//psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`/test_data/*  $SJ_PATH_PSDKRA/tiovx/conformance_tests/test_data/
			# update the soc tidl module
		
#			cp -rv $REPO_INSTALL_PATH//psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`/test_data/psdkra $SJ_PATH_PSDKRA/tiovx/conformance_tests/test_data/tidl_models/$SJ_SOC_TYPE
#			cp -rv $REPO_INSTALL_PATH//psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`/test_data/tivx   $SJ_PATH_PSDKRA/tiovx/conformance_tests/test_data/tidl_models/$SJ_SOC_TYPE
		else
			 sh_log debug_plus "- already untar the package :$REPO_INSTALL_PATH "
		fi  
	else 
		sh_log debug_plus "- file is not exist please check"
	fi
}

# Starting to run
sh_log info "[ $0 ] start... "
# Current Dictionary name : 
sh_get_dirtionary_name cwd_c
sh_log debug "running dictionary:  ./$cwd_c" 

sh_check_args $*
update_args_value $*
# --------------------------------------------------------------------------------------------------------------------------------
# - package link URL and data link URL1 
# APP_DOWNLOAD_URL="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION.tar.gz" # github repo
# APP_DOWNLOAD_URL1="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
# APP_DOWNLOAD_URL2="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION-prebuilt.tar.gz"
if [ $SJ_SOC_TYPE == "j721e" ];then
	LINK_ADDR="MD-bA0wfI4X2g"
	sh_log debug "link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "j721s2" ];then
	LINK_ADDR="MD-50weZVBfzl"
	sh_log debug "link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "j784s4" ];then
	LINK_ADDR="MD-zv2DZbDzFz"
	sh_log debug "link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "am62axx" ];then
	LINK_ADDR="MD-b4i0McWpWx"
	sh_log debug "link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "am62xx" ];then
	LINK_ADDR="MD-IIN1zFBAlS"
	sh_log debug "link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
else 
	echo " not support , pls check LINK_ADDR... "; 
	exit 1
fi

# https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-b4i0McWpWx/08.06.00.18/mcu_plus_sdk_am62ax_08_06_00_18-linux-x64-installer.run
# https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-b4i0McWpWx/08.06.00.18/ti-processor-sdk-rtos-am62axx-evm-08_06_00_18.tar.gz
# https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-IIN1zFBAlS/08.06.00.18/mcu_plus_sdk_am62x_08_06_00_18-linux-x64-installer.run
# https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-IIN1zFBAlS/08.06.00.18/mcu_plus_sdk_am62x-08_06_00_18-linux-x64-installer.run
if [ $SJ_SOC_TYPE == "am62xx" ] || [ $SJ_SOC_TYPE == "am62axx" ];then
	APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/mcu_plus_sdk_`echo $SJ_SOC_TYPE | sed s/xx/x/g`_$VERSION-linux-x64-installer.run" # github repo
else
	APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION.tar.gz" # github repo
fi
APP_DOWNLOAD_URL1="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
APP_DOWNLOAD_URL2="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz"
APP_DOWNLOAD_URL3="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_$SJ_SOC_TYPE.tar.gz"

# -------------------------------------------------------------------------------------------------------------------------------------
parse_args
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
