#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-26                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p )

# LOG _LEVEL:  0 (error), 1 (info) , 2(debug) , 3 (debug_plus)
LOG_LEVEL=1

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/downloads/
VERSION="08_01_00_07"
SETUP_YES_NO="no"
CPU_NUM=`nproc`

. $SJ_PATH_JACINTO/scripts/ubuntu/common_ubuntu.sh

# --- usage introduction. 
usage()
{
echo -e " Usage: $0 <options> 
	# $0 - To print help infomation
	# $0 --help      |  -h   : print help infomation.
	Mandatory options:
	--path    | -p           : install PATH

	Optional options:
	--verbose | -v           : verbose print output.
	--version | -s           : set the version (Default : $VERSION )
	--install | -i           : default no, set yes

More details , please visit : xxx
"
}

# update args value
# $1 : $*
update_args_value()
{
	# loop args and set the variable
	args_list=$* 
	# sh_log info "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		# sh_log info " args : $args"
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
			"*")
				sh_log CRITICAL "option is not correct, please check!!!"
				;;
		esac
	done
}
# --- parse arguments
parse_args()
{  
	sh_log debug "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
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
		sh_log info "${FUNCNAME[0]}: args --- $SETUP_YES_NO" 
		if [ $SETUP_YES_NO == "yes" ];then
			setup_release_app
			# setup_src_app
			# echo "test"
			# update_packge_to_target_dictionary
		else
			sh_log CRITICAL "${FUNCNAME[0]}: please use -i yes to setup" 
		fi
	fi
}

setup_release_app()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. download the package" 
	local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	sh_log debug_plus "Pkg_name : $Pkg_name" 
	# echo "- $Pkg_name"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/$Pkg_name ]; then
			sh_log debug_plus "- $REPO_INSTALL_PATH/$Pkg_name "
			cd $REPO_INSTALL_PATH &&  /usr/bin/wget $APP_DOWNLOAD_URL; 
			sh_log debug_plus "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		else 
			sh_log debug_plus "- download the sdk."
		fi
	else 
		sh_log debug_plus "- Already downloaded. please continuing ---"
	fi
	sh_log debug "2. install the sdk. " 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		# echo "- $REPO_INSTALL_PATH/$Pkg_name "
		cd $REPO_INSTALL_PATH && chmod a+x  ./$Pkg_name ; 
		# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		if [ ! -d $APP_INSTALL_PATH ];then
			sh_log debug_plus "- setup the :$APP_INSTALL_PATH  "
			cd $SJ_PATH_SCRIPTS/j7/ && ./expect/expect_psdkla.sh $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH
			# cd $REPO_INSTALL_PATH/ && ./$Pkg_name
		else
			sh_log debug_plus "- already setup the :$APP_INSTALL_PATH "
		fi  
	else 
		sh_log debug_plus "- file is not exist please check"
	fi
	sh_log debug "3. install the dependency " 
	if [  -d $APP_INSTALL_PATH ];then
		# sudo apt update
		cd $SJ_PATH_SCRIPTS/j7/ && ./expect/expect_psdkla_setup.sh  $APP_INSTALL_PATH/setup.sh $APP_INSTALL_PATH
		# cd $APP_INSTALL_PATH &&  ./setup.sh; 
	else 
		sh_log debug_plus "package is not exist, please check"
	fi

	sh_log debug "4. installed done  " 
	sh_log info "please run: make la-install-addon-makefile to support update image to SD card:" ;

}


setup_src_app()
{
	#TODO check this config... 
	sh_log info "[ $(date) ] --- ${FUNCNAME[0]}: 0 args --- $#" 
}

# Starting to run
common_ubuntu_test
sh_log info "[ $0 ] start... "
# Current Dictionary name : 
sh_get_dirtionary_name cwd_c
sh_log debug "running dictionary:  ./$cwd_c" 

sh_check_args $*
update_args_value $*

if [ $SJ_SOC_TYPE == "j721e" ];then
	LINK_ADDR="MD-U6uMjOroyO"
	psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
	if [ $(($psdkla_ver)) -gt $(("9000000")) ];then
		SOC_TYPE_temp=$SJ_SOC_TYPE
	else
		SOC_TYPE_temp="j7"
	fi
	sh_log info "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "j721s2" ];then
	LINK_ADDR="MD-Snl3iJzGTW"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	sh_log info "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "j784s4" ];then
	LINK_ADDR="MD-lOshtRwR8P"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	sh_log info "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "am62axx" ];then
	LINK_ADDR="MD-D37Ls3JjkT"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	sh_log info "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "am62xx" ];then
	LINK_ADDR="MD-PvdSyIiioq"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	sh_log info "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
else
	sh_log error " not support , pls check LINK_ADDR... "; 
	exit 1
fi

# AM62Axx version using xx.xx.xx.xx , TDA4 using xx_xx_xx_xx
psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
if [ $SJ_SOC_TYPE == "am62axx" ];then
	APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-$SOC_TYPE_temp-evm-`echo $VERSION | sed s/_/./g`-Linux-x86-Install.bin"
elif [ $SJ_SOC_TYPE == "am62xx" ];then
	APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-$SOC_TYPE_temp-evm-`echo $VERSION | sed s/_/./g`-Linux-x86-Install.bin"
else 
	if [ $(($psdkla_ver)) -gt $(("9000000")) ];then
		echo "version > $(($psdkla_ver))  vs $(("9000000"))"
		APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-adas-$SOC_TYPE_temp-evm-$VERSION-Linux-x86-Install.bin" 
	else
		echo "version <= $(($psdkla_ver)) vs $(("9000000"))"
		APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-$SOC_TYPE_temp-evm-$VERSION-Linux-x86-Install.bin" 
	fi
fi

psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
# APP_DOWNLOAD_URL="https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/$VERSION/exports/ti-processor-sdk-linux-j7-evm-$VERSION-Linux-x86-Install.bin" # github repo
# APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-U6uMjOroyO/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-j7-evm-$VERSION-Linux-x86-Install.bin" # github repo
# APP_DOWNLOAD_URL1="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-Snl3iJzGTW/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-linux-j721s2-evm-$VERSION-Linux-x86-Install.bin" # github rep
# AM62A : https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-D37Ls3JjkT/08.06.00.45/ti-processor-sdk-linux-am62axx-evm-08.06.00.45-Linux-x86-Install.bin
#         https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-D37Ls3JjkT/08.06.00.45/ti-processor-sdk-linux-am62axx-evm-08_06_00_45-Linux-x86-Install.bin
# APP_DOWNLOAD_URL1="https://github.com/protocolbuffers/protobuf/archive/refs/tags/v$VERSION.tar.gz"
#----------------------------------------------------------------------------------------------------------------------------------
parse_args
# Launch the application:  $1 : number of args
launch $# 
sh_log info "[ $0 ] done   !!!"
#---------------------------------------------------------------------------
