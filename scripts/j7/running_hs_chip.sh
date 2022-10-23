#!/bin/bash

#############################################################################################
# This script is using for installing the keywriter                                         #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-18 
# @update : fredy  V1                                                                       # 
##############################################################################################

VALID_ARGS=(--list -l --help -h --ver -v --pdk_path -p --addon -a )
# LOG _LEVEL: debug or no
LOG_LEVEL=no
# update your key 
UPDATE_ADDON=yes
UPDATE_KEY=yes

# KEYWRITER_NAME
KEYWRITER_NAME=""
PDK_PATH=""
ADDON_WWW=""


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
echo " Usage: `basename $1` <options> [ files for install partition ]
	[ $(date) ] >>> # $0 - To launch the startJacinto tools
	[ $(date) ] >>> # $0 --list      |  -l   : list
	[ $(date) ] >>> # $0 --help      |  -h   : help
	[ $(date) ] >>> # $0 --ver       |  -v   : version
	[ $(date) ] >>> # $0 --pdk_path  |  -p   : pdk path 
	[ $(date) ] >>> # $0 --addon     |  -a   : addon patch 
	Mandatory options:
	--ver                   keywriter Package. 
	--pdk_path              pdk_path. 

	Optional options:
	--sdk                 Path to SDK directory
	--version             Print version.
	--help                Print this help message.
"
}

# --- check the arguments
check_args()
{

	echo_log "[ $(date) ] >>> $0 starting check args  >>> " 
	if [ "$1" == "" ]
	then
		return 0
	fi
	for i in "${VALID_ARGS[@]}"
	do
		if [ "$1" == "$i" ]
		then
			return 0
		fi
	done
	usage
	exit 0
}

# --- parse arguments
parse_args()
{  
	echo_log "[ $(date) ] >>> starting parse args >>>>> " 

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
	echo_log "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		echo_log " args : $args"
		case $args in
			"--list" | "-l")
				usage
				;;
			"--help" | "-h")
				usage
				;;
			"--ver" | "-v")
				get_arg_value KEYWRITER_NAME $# $args $args_list
				echo_log "-----KEY_WRITER_VERSION: $KEYWRITER_NAME"
				;;
			"--pdk_path" | "-p")
				get_arg_value PDK_PATH $# $args $args_list
				echo_log "-----PDK_PATH: $PDK_PATH"
				;;
			"--addon" | "-a")
				get_arg_value ADDON_WWW $# $args $args_list
				echo_log "-----ADDON_WWW: $ADDON_WWW"
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
	echo_log "[ $(date) ] >>> starting parse args >>>>> " 
	# check the KEYWRITER VERSION NAME and PDK PATH. 
	if [ -d $PDK_PATH ]
	then
		echo_log "- parse_args: PDK_PATH --> $PDK_PATH"
	else 
		echo "- parse_args: PDK_PATH is not exist, please check $PDK_PATH"
		exit 1
	fi

	if [ -f $KEYWRITER_NAME ]
	then
		echo_log "- parse_args: KEYWRITER_NAME --> $KEYWRITER_NAME"
	else 
		echo "- parse_args: KEYWRITER_NAME is not exist, please check $KEYWRITER_NAME"
		exit 1
	fi

}
# --- run application
launch()
{
	echo_log "[ $(date) ] >>> launch the application >>>" 

	echo_log "[ $(date) ] - 1. run:  $KEYWRITER_NAME >>>" 
	if [ ! -d $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1` ]
	then
		echo_log "[ $(date) ] - 1 run -setup:  $KEYWRITER_NAME >>>" 
		chmod 777 $KEYWRITER_NAME
		./expect/expect_keywriter.sh $KEYWRITER_NAME $PDK_PATH   # using the variable $SJ_KEYWRITER
	else 
		echo "[ $(date) ] - 1 $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1` not exist, please check >>>" 
	fi
	echo_log "[ $(date) ] - 1. run - done >>>" 

	# install openssl  
	echo_log "[ $(date) ] - 2.3 install openssl >>>" 
	if [ ! -f /usr/bin/openssl ]
	then
		sudo apt install openssl 
	fi
	# update addon package and additional patches. 
	if [ $UPDATE_ADDON == "yes" ]
	then  
		echo_log "[ $(date) ] - 2.4 download addon patch: $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9` >>>" 
		if [ ! -f $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9` ]
		then
			cd $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/ && wget $ADDON_WWW
		fi

		echo_log "[ $(date) ] - 2.5 setup addon patch: $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9` >>>" 
		if [ -f $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9` ]
		then
			echo_log "[ $(date) ] - 2.5.1  untar  `echo $ADDON_WWW | cut -d / -f 9`  $PDK_PATH/packages/ti/boot/keywriter >>>" 
			cd $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/ && tar -zxvf `echo $ADDON_WWW | cut -d / -f 9`
			if [ -d $PDK_PATH/packages/ti/boot/keywriter ]
			then
				rm -r $PDK_PATH/packages/ti/boot/keywriter
				echo_log "[ $(date) ] - 2.5.2  update pdk keywriter package  >>>" 
				echo_log "unzip   $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9 | cut -d . -f 1`/keywriter.zip -d $PDK_PATH/packages/ti/boot"
				unzip $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/`echo $ADDON_WWW | cut -d / -f 9 | cut -d . -f 1`/keywriter.zip -d $PDK_PATH/packages/ti/boot

				echo_log "[ $(date) ] - 2.5.3 update  $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon/ti-fs-keywriter.bin >>>" 
				if [ -f $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon/ti-fs-keywriter.bin ]
				then
					echo_log "[ $(date) ] - 2.5.3  update  $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin >>>" 
					cp $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon/ti-fs-keywriter.bin \
						$PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin
				else 
					echo "[ $(date) ] - 2.5.3  $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin is not exist, please check !!!" 
				fi
				
				echo_log "[ $(date) ] - 2.5.4 update  $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon/ti_fek_public.pem >>>" 
				if [ -f $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon/ti_fek_public.pem ]
				then
					echo_log "[ $(date) ] - 2.5.4 update  $PDK_PATH/packages/ti/boot/keywriter/scripts/ti_fek_public.pem >>>" 
					cp $PDK_PATH/`echo $KEYWRITER_NAME | cut -d / -f 6 | cut -d . -f 1`/addon//ti_fek_public.pem \
						$PDK_PATH/packages/ti/boot/keywriter/scripts/ti_fek_public.pem
				else 
					echo "[ $(date) ] - 2.5.4  $PDK_PATH/packages/ti/boot/keywriter/scripts/ti_fek_public.pem is not exist, please check !!!" 
				fi
			fi
		fi
	fi

	echo_log "[ $(date) ] - 3 update your key:  >>>" 
	if [ $UPDATE_KEY == "yes" ]
	then
		sudo chmod 777 $PDK_PATH/packages/ti/boot/keywriter/scripts/*.sh
		cd $PDK_PATH/packages/ti/boot/keywriter/scripts && ./gen_keywr_cert.sh -g
		ls -l $PDK_PATH/packages/ti/boot/keywriter/scripts/keys 
		ls -l $PDK_PATH/packages/ti/boot/keywriter/scripts/ti_fek_public.pem
		sync
	else
		echo "[ $(date) ] - 3 didn't generate your new key , if you want : pelase set : UPDATE_KEY = yes in this scripts >>>" 
	fi

	echo_log "[ $(date) ] - 4 generate x509 certification:  $PDK_PATH/packages/ti/boot/keywriter/scripts/gen_keywr_cert.sh check the help>>>" 
	# cd $PDK_PATH/packages/ti/boot/keywriter/scripts && ./gen_keywr_cert.sh # -s ./keys/smpk.pem --smek ./keys/smek.key -t keys/tifekpub.pem -a ./keys/aes256.key
	cd $PDK_PATH/packages/ti/boot/keywriter/scripts && ./gen_keywr_cert.sh  -s keys/smpk.pem --smek keys/smek.key -b keys/bmpk.pem --bmek keys/bmek.key -t ./ti_fek_public.pem -a ./keys/aes256.key
	
	echo_log "[ $(date) ] - 5 build PDK Keywriter App：>>>" 
	echo_log "[ $(date) ] - 5.1 build PDK Keywriter App：>>>" 
	if [ -f $PDK_PATH/packages/ti/boot/keywriter/x509cert/final_certificate.bin ] && \
	   [ -f $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin ]
	then
		cd $PDK_PATH/packages/ti/build/ && make keywriter_img_clean 
		cd $PDK_PATH/packages/ti/build/ && make keywriter_img -j8
	else 
		echo "pelase check the below file : "
		echo "	$PDK_PATH/packages/ti/boot/keywriter/x509cert/final_certificate.bin "
		echo "	$PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin "
	fi
	echo "[ $(date) ] Key Writer Tools: $PDK_PATH/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin"

	# When you have prepared the keywriter , Please follow below step to flash the Keys to eFuse. 
	# 	1. Keywriter as step 5: keywriter_img_j721e_release.bin
	#	2. prepared the TIFS for DMSC firmware: provided in the keywriter tifs_bin:
	if [ -f $PDK_PATH/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin  ]
	then
		echo "[ $(date) ] keywriter_img_j721e_release.bin is exist: $PDK_PATH/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin"
	else 
		echo "[ $(date) ] keywriter_img_j721e_release.bin is not exist, please check: $PDK_PATH/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin"
	fi
	if [ -f $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin  ]
	then
		echo "[ $(date) ] ti-fs-keywriter.bin  is exist: $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin"
	else 
		echo "[ $(date) ] ti-fs-keywriter.bin  is not exist, please check: $PDK_PATH/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin"
	fi

	echo "[ $(date) ] : It's ready for flashing the images"
}

# Starting to run
echo "[ $(date) $0] start---"
check_args $1
update_args_value $*
parse_args $1
# Run Install
launch 

echo "[ $(date) $0] done!!!"
#---------------------------------------------------------------------------
