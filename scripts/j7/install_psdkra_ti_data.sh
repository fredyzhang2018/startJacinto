#!/bin/bash
#############################################################################################
# This script is using for installing the TI data set.                       #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-12-13                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p )

# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/downloads/
VERSION="08_04_00_06"
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

	local Pkg_name=`echo $APP_DOWNLOAD_URL1 | cut -d / -f 8` #TODO please check 
	local Pkg_name1=`echo $APP_DOWNLOAD_URL2 | cut -d / -f 8` #TODO please check 
	echo " --- Pkg_name :  $Pkg_name"
	echo " --- Pkg_name1:  $Pkg_name1"
	local Pkg_Dir=`echo $Pkg_name| cut -d . -f 1`
	# echo "- $Pkg_name $Pkg_Dir"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/$Pkg_name ]; then
			# download the URL1 : data set.
			# SDK0804 start to add SOC TYPE . 
				echo " --- Pkg_name3:   $REPO_INSTALL_PATH/$Pkg_name1"
			if [ ! -f $REPO_INSTALL_PATH/$Pkg_name1 ]; then
				echo "- download $REPO_INSTALL_PATH/$Pkg_name1 ..."
				cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL2;
				if [ $? ];then
					echo "- download $REPO_INSTALL_PATH/$Pkg_name..."
					cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL1;
					echo "- download $REPO_INSTALL_PATH/$Pkg_name done!"
				else 
					echo "- download $REPO_INSTALL_PATH/$Pkg_name1 done!"
				fi
			else 
				echo " - $REPO_INSTALL_PATH/$Pkg_name1 already installed !"
			fi 
		else
			echo "- $REPO_INSTALL_PATH/$Pkg_name already exist!"
		fi
	else 
		echo "- Already setup. please continuing ---"
	fi
	echo_log "[ $(date) ] - 2. update the dataset to SD" 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		echo "- update the $REPO_INSTALL_PATH/$Pkg_name to /media/$USER/rootfs/"
		if [ -d /media/$USER/rootfs/ ]; then 
			cd /media/$USER/rootfs/ && mkdir -p opt/vision_apps
			cd /media/$USER/rootfs/opt/vision_apps && tar --strip-components=1 -xf ${SJ_PATH_DOWNLOAD}/$Pkg_name
			sync
			echo "- update the $REPO_INSTALL_PATH/$Pkg_name to /media/$USER/rootfs/ done"
		else 
			echo " /media/$USER/rootfs/ is not exist, please check ..."
		fi 
	elif [ -f  $REPO_INSTALL_PATH/$Pkg_name1 ];then
		echo "- update the $REPO_INSTALL_PATH/$Pkg_name1 to /media/$USER/rootfs/"
		if [ -d /media/$USER/rootfs/ ]; then 
			cd /media/$USER/rootfs/ && mkdir -p opt/vision_apps
			cd /media/$USER/rootfs/opt/vision_apps && tar --strip-components=1 -xf ${SJ_PATH_DOWNLOAD}/$Pkg_name1
			sync
			echo "- update the $REPO_INSTALL_PATH/$Pkg_name1 to /media/$USER/rootfs/ done"
		else 
			echo " /media/$USER/rootfs/ is not exist, please check ..."
		fi 
	else 
		echo "- file is not exist please check"
	fi

	# echo_log "[ $(date) ] - 3. update the tiny filesystem" 
	# if [ -d /media/$USER/rootfs/ ]; then 
	# 	sudo cp -r $SJ_PATH_PSDKLA/targetNFS/boot/* /media/$USER/rootfs/boot
	# 	sudo cp -r $SJ_PATH_PSDKLA/targetNFS/lib/* /media/$USER/rootfs/lib
	# 	sudo cp -r $SJ_PATH_PSDKLA/targetNFS/usr/lib/* /media/$USER/rootfs/usr/lib/
	# 	sudo cp -r $SJ_PATH_PSDKLA/targetNFS/etc/* /media/$USER/rootfs/etc/
	# fi
}

# Starting to run
echo "[ $(date) $0] start---"
# Current Dictionary name : 
cwd_c=`dirname $0`
cwd=`pwd`/$cwd_c
echo_log "[ $(date) ] --- running dictionary:  $cwd" 
check_args $*
update_args_value $*
# --------------------------------------------------------------------------------------------------------------------------------
# - package link URL and data link URL1 
# APP_DOWNLOAD_URL="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION.tar.gz" # github repo
# APP_DOWNLOAD_URL1="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
# APP_DOWNLOAD_URL2="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION-prebuilt.tar.gz"

APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-bA0wfI4X2g/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION.tar.gz" # github repo
APP_DOWNLOAD_URL1="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-bA0wfI4X2g/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
APP_DOWNLOAD_URL2="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-bA0wfI4X2g/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_j721e.tar.gz"
# -------------------------------------------------------------------------------------------------------------------------------------
parse_args
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
