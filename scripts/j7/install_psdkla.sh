#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-26                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p )

# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/downloads/
VERSION="08_01_00_07"
SETUP_YES_NO="no"
CPU_NUM=`nproc`


# --- log 
echo_log() # $1 print infomation
{
	if [ $LOG_LEVEL == "debug" ]; then
		echo $1
	fi
}

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

More details , please visit : xxx
"
}


# --- check the arguments
#   input : args 
check_args()
{
	# TODO : modification the files. 
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
    if [ "$1" == "" ]
    then
        usage
        return 0
	else 
		for i in "${VALID_ARGS[@]}"
		do
			if [ "$1" == "$i" ]
			then
				return 0
			fi
		done
		usage
		exit 0
    fi
}

# --- get args value: 
#  $1 output string. 
#  $2 args number. 
#  #3 input flag.
#  $n : input args
get_arg_value() 
{
	local _Output=$1
	local ArgsNum=$2
	local ArgsFlag=$3
	local ArgsList=$@
	echo_log "- get_arg_value: ArgsList:  $ArgsList"
	
	for i in $(seq 4 `expr $2 + 2`)  
	do
		echo_log "- get_arg_value:  check : $i $3 `eval echo "$"$i""`"
		if [ `eval echo "$"$i""` == $ArgsFlag  ] 
		then
			echo_log "- get_arg_value: get  $ArgsFlag- `eval echo "$"$((i+1))""`"
			eval $_Output="`eval echo "$"$((i+1))""`"
		fi 
	done
}

# update args value
# $1 : $*
update_args_value()
{
	# loop args and set the variable
	args_list=$* 
	# echo_log "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		# echo_log " args : $args"
		case $args in
			"--help" | "-h")
				usage
				;;
			"--verbose" | "-v")
				LOG_LEVEL="debug"
				echo_log "--- -v LOG_LEVEL: $LOG_LEVEL"
				;;
			"--version" | "-s")
					get_arg_value VERSION $# $args $args_list
					echo_log "--- -s VERSION: $VERSION"
				;;
			"--install" | "-i")
					get_arg_value SETUP_YES_NO $# $args $args_list
					echo_log "--- -i SETUP_YES_NO: $SETUP_YES_NO"
					;;
			"--path" | "-p")
				get_arg_value APP_INSTALL_PATH $# $args $args_list
				echo_log "--- -p APP_INSTALL_PATH: $APP_INSTALL_PATH"
				;;
			"*")
				echo "option is not correct, please check!!!"
				;;
		esac
	done
}
# --- parse arguments
parse_args()
{  
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
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
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	local num_args=$1
	if [ $num_args == 0 ]
	then
		usage
	else 
		echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $SETUP_YES_NO" 
		if [ $SETUP_YES_NO == "yes" ];then
			setup_release_app
			# setup_src_app
			# echo "test"
			# update_packge_to_target_dictionary
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -i yes to setup" 
		fi
	fi
}

setup_release_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	echo_log "[ $(date) ] - 1. download the package" 
	local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	echo_log "[ $(date) ] --- Pkg_name : $Pkg_name" 
	# echo "- $Pkg_name"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/$Pkg_name ]; then
			echo "- $REPO_INSTALL_PATH/$Pkg_name "
			cd $REPO_INSTALL_PATH &&  /usr/bin/wget $APP_DOWNLOAD_URL; 
			echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		else 
			echo "- download the sdk."
		fi
	else 
		echo "- Already downloaded. please continuing ---"
	fi
	echo_log "[ $(date) ] - 2. install the sdk. " 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		# echo "- $REPO_INSTALL_PATH/$Pkg_name "
		cd $REPO_INSTALL_PATH && chmod a+x  ./$Pkg_name ; 
		# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		if [ ! -d $APP_INSTALL_PATH ];then
			echo "- setup the :$APP_INSTALL_PATH $cwd   "
			cd $cwd && ./expect/expect_psdkla.sh $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH
			# cd $REPO_INSTALL_PATH/ && ./$Pkg_name
		else
			 echo "- already setup the :$APP_INSTALL_PATH "
		fi  
	else 
		echo "- file is not exist please check"
	fi
	echo_log "[ $(date) ] - 3. install the dependency " 
	if [  -d $APP_INSTALL_PATH ];then
		# sudo apt update
		cd $cwd && ./expect/expect_psdkla_setup.sh  $APP_INSTALL_PATH/setup.sh $APP_INSTALL_PATH
		# cd $APP_INSTALL_PATH &&  ./setup.sh; 
	else 
		echo "package is not exist, please check"
	fi

	echo_log "[ $(date) ] - 4. installed done  " 
	echo "please run: make la-install-addon-makefile to support update image to SD card:" ;

}


setup_src_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 0 args --- $#" 

}

# Starting to run
echo "[ $(date) $0] start---"
# Current Dictionary name : 
cwd_c=`dirname $0`
cwd=`pwd`/$cwd_c
echo_log "[ $(date) ] --- running dictionary:  $cwd/install_psdkla.sh" 
check_args $*
update_args_value $*

if [ $SJ_SOC_TYPE == "j721e" ];then
	LINK_ADDR="MD-U6uMjOroyO"
	psdkla_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
	if [ $(($psdkla_ver)) -gt $(("9000000")) ];then
		SOC_TYPE_temp=$SJ_SOC_TYPE
	else
		SOC_TYPE_temp="j7"
	fi
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "j721s2" ];then
	LINK_ADDR="MD-Snl3iJzGTW"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "j784s4" ];then
	LINK_ADDR="MD-lOshtRwR8P"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "am62axx" ];then
	LINK_ADDR="MD-D37Ls3JjkT"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
elif [ $SJ_SOC_TYPE == "am62xx" ];then
	LINK_ADDR="MD-PvdSyIiioq"
	SOC_TYPE_temp=$SJ_SOC_TYPE
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR  $SOC_TYPE_temp"
else
	echo " not support , pls check LINK_ADDR... "; 
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
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
