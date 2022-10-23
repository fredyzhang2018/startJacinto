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
VERSION="08_01_00_11"
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
	if [ $SJ_SOC_TYPE == "j721e" ];then
		local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8` #TODO please check 
	else 
		local Pkg_name=`echo $APP_DOWNLOAD_URL | cut -d / -f 8 | sed s/j721e/$SJ_SOC_TYPE/g` #TODO please check 
	fi
	echo " ---------------------- $Pkg_name"
	local Pkg_Dir=`echo $Pkg_name| cut -d . -f 1`
	# echo "- $Pkg_name $Pkg_Dir"
	if [ -d $REPO_INSTALL_PATH ];then
		if [ ! -f $REPO_INSTALL_PATH/$Pkg_name ]; then
			# echo "- $REPO_INSTALL_PATH/$Pkg_name "
			# download the URL : package
			cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL;
			# download the URL1 : data set.
			cd $REPO_INSTALL_PATH &&  wget $APP_DOWNLOAD_URL1;
			# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		else 
			echo "- download the sdk."
		fi
	else 
		echo "- Already setup. please continuing ---"
	fi
	echo_log "[ $(date) ] - 2. install the sdk. " 
	if [ -f $REPO_INSTALL_PATH/$Pkg_name ]; then
		# echo "- $REPO_INSTALL_PATH/$Pkg_name download done!"
		if [ ! -d $APP_INSTALL_PATH/$Pkg_Dir ];then
			# echo "- setup the :$APP_INSTALL_PATH $cwd   "
			# echo "- $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH/../ "
			# echo "cd $REPO_INSTALL_PATH && tar -zxvf $Pkg_name.tar.gz -C $APP_INSTALL_PATH/../"
			cd $REPO_INSTALL_PATH && tar -zxvf ./$Pkg_name -C $APP_INSTALL_PATH
			cd $APP_INSTALL_PATH/$Pkg_Dir
			if [ ! -d $APP_INSTALL_PATH/$Pkg_Dir/.git ] ; then 
				cd $APP_INSTALL_PATH/$Pkg_Dir && git init;
				ln -s $APP_INSTALL_PATH/../resource/psdkra/gitignore $APP_INSTALL_PATH/$Pkg_Dir/.gitignore ; 
				cd $APP_INSTALL_PATH/$Pkg_Dir && git add -A ;
				cd $APP_INSTALL_PATH/$Pkg_Dir && git commit -m "repo init" ;
			else 
				echo "Git already setup : $APP_INSTALL_PATH/$Pkg_Dir "; 
			fi
			# cd $cwd && ./expect/expect_psdkla.sh $REPO_INSTALL_PATH/$Pkg_name $APP_INSTALL_PATH
			# cd $REPO_INSTALL_PATH/ && ./$Pkg_name
		else
			 echo "- already setup the :$APP_INSTALL_PATH "
		fi  
	else 
		echo "- file is not exist please check"
	fi
	echo_log "[ $(date) ] - 3. setup the prebuilt images: $SJ_PATH_PSDKLA  $SJ_PATH_PSDKRA" 
	if [ ! -f $SJ_PATH_PSDKRA/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz ] ; then
		cd $SJ_PATH_PSDKRA && wget $APP_DOWNLOAD_URL2 ; 
	else 
		echo "prebuild image already setup:$SJ_PATH_PSDKRA/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz "; 
	fi
	echo_log "[ $(date) ] - 4. the install the filesystem to PSDKRA path. $SJ_PATH_PSDKLA  $SJ_PATH_PSDKRA" 

	if [ $SJ_SOC_TYPE == "j721e" ];then
		if [ ! -f $SJ_PATH_PSDKRA/boot-j7-evm.tar.gz ] ; then
			cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/boot-j7-evm.tar.gz $SJ_PATH_PSDKRA ; 
		else 
			echo "- boot image already setup:$SJ_PATH_PSDKRA/boot-j7-evm.tar.gz "; 
		fi
	else
		if [ ! -f $SJ_PATH_PSDKRA/boot-$SJ_SOC_TYPE-evm.tar.gz ] ; then
			cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/boot-$SJ_SOC_TYPE-evm.tar.gz $SJ_PATH_PSDKRA ; 
		else 
			echo "- boot image already setup:$SJ_PATH_PSDKRA/boot-$SJ_SOC_TYPE-evm.tar.gz "; 
		fi
	fi

	if [ $SJ_SOC_TYPE == "j721e" ];then
		if [ ! -f $SJ_PATH_PSDKRA/tisdk-default-image-j7-evm.tar.xz ] ; then 
			cp $SJ_PATH_PSDKLA/board-support/prebuilt-images/tisdk-default-image-j7-evm.tar.xz $SJ_PATH_PSDKRA ; 
		else 
			echo "- filesystem already setup: $SJ_PATH_PSDKRA/tisdk-default-image-j7-evm.tar.xz "; 
		fi
	else
		if [ ! -f $SJ_PATH_PSDKRA/tisdk-default-image-$SJ_SOC_TYPE-evm.tar.xz ] ; then 
			cp $SJ_PATH_PSDKLA/filesystem/tisdk-default-image-$SJ_SOC_TYPE-evm.tar.xz $SJ_PATH_PSDKRA ; 
		else 
			echo "- filesystem already setup: $SJ_PATH_PSDKRA/tisdk-default-image-j7-evm.tar.xz "; 
		fi
	fi
	echo_log "[ $(date) ] - 5. install dependcy tools " 
	cd $SJ_PATH_PSDKRA && ./psdk_rtos/scripts/setup_psdk_rtos.sh
	echo_log "[ $(date) ] - 6.  Ready to compiling. " 
	echo_log "- download the sdk from secure SW: install add on package for run PC demo. "
	echo_log "- chmod a+x ./$Pkg_Dir-addon-linux-x64-SJ_INSTALLER.run "	
	echo_log "- ./$Pkg_Dir-addon-linux-x64-SJ_INSTALLER.run "	
	echo_log "- PSDKRA Ready to use, congrations!  "	
	echo_log "[ $(date) ] - 7. installed done !!! " 
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
APP_DOWNLOAD_URL2="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-bA0wfI4X2g/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz"
# -------------------------------------------------------------------------------------------------------------------------------------
parse_args
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
