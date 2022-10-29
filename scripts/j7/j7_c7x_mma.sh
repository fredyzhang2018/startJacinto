#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-24                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################

VALID_ARGS=( --help -h --install -i --verbose -v  --build -b )

# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# variable : 
VERSION=`ls $SJ_PATH_PSDKRA | grep tidl_ | sed s/tidl_${SJ_SOC_TYPE}_//g`
URL_C7x_TRAINING="ssh://git@bitbucket.itg.ti.com/processor-sdk-vision/c7x-mma-training.git"
URL_C7x_REPO="ssh://git@bitbucket.itg.ti.com/processor-sdk-vision/c7x-mma-tidl.git"
URL_C7x_SRC="http://bangsdowebsvr01.india.ti.com/TIDeepLearningProduct/$SJ_SOC_TYPE/$VERSION/exports/tidl_src_${SJ_SOC_TYPE}_$VERSION.bin"
#            http://bangsdowebsvr01.india.ti.com/TIDeepLearningProduct/j721e/08_02_00_11/exports/tidl_src_j721e_08_02_00_11.bin
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

	Optional options:
	--verbose | -v           : verbose print output.
	--install | -i           : install the tidl.
	--build   | -b           : build tidl : pc or evm

More details , please visit : http://bangsdowebsvr01.india.ti.com/TIDeepLearningProduct
							  http://bitbucket.itg.ti.com/processor-sdk-vision/c7x-mma-tidl.git
	internal docs: $SJ_PATH_JACINTO/docs/jacinto7/jacinto7_module_TIDL.md 
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
	echo_log "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		echo_log " args : $args"
		case $args in
			"--help" | "-h")
				usage
				;;
			"--install" | "-i")
                # if workarea clone_c7x_repo else setup the source code. 
				if [ $SJ_PATH_PSDKRA == "/ti/j7/workarea" ];then
					clone_c7x_repo
				else
					# echo "not workarea"
					install_tidl_src
				fi
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
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	# check the KEYWRITER VERSION NAME and PDK PATH. 
}

# --- install sphinx
clone_c7x_repo()
{  
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#  PSDKRA_PATH:   $SJ_PATH_PSDKRA" 
	if [ -d  $SJ_PATH_PSDKRA ];then
		if [ ! -d $SJ_PATH_PSDKRA/tidl ];then
			cd $SJ_PATH_PSDKRA && git clone $URL_C7x_REPO $SJ_PATH_PSDKRA/tidl
		else 
			echo  " - already clone the repo : $SJ_PATH_PSDKRA/tidl the  done !!! " 
		fi
	fi
	
}

# --- install sphinx
install_tidl_src()
{  
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#  PSDKRA_PATH:   $SJ_PATH_PSDKRA" 
	local tidl_src_name=`echo $URL_C7x_SRC | awk -F"/" '{print $8 }' | awk -F"." '{print $1}'`
	echo "- tidl_src_name=$tidl_src_name"
	if [ -d  $SJ_PATH_JACINTO/downloads ] && [ ! -f $SJ_PATH_JACINTO/downloads/$tidl_src_name.bin ] ;then
		echo "downloading----------$URL_C7x_SRC------------------------"
		cd $SJ_PATH_JACINTO/downloads && wget $URL_C7x_SRC
	else 
		echo "- already installed : $SJ_PATH_JACINTO/downloads/$tidl_src_name.bin"
	fi
	# install the src to PSDKRA 
	if [ -f $SJ_PATH_JACINTO/downloads/$tidl_src_name.bin ] && [ -d $SJ_PATH_PSDKRA ];then 
		if [ ! -d $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/tidl_src_${SJ_SOC_TYPE}_$VERSION ];then
			# install   :   tidl_src_bin          PATH_PSDKRA/tidl
			$SJ_PATH_JACINTO/scripts/j7/expect/expect_tidl_src.sh $SJ_PATH_JACINTO/downloads/$tidl_src_name.bin  $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/ # using the variable $SJ_KEYWRITER
			cp -r $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/tidl_src_${SJ_SOC_TYPE}_$VERSION/*  \
				$SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/
			sync
			cd $SJ_PATH_PSDKRA/ && git add -A && git commit -m "update tidl src"
		else 
			echo "- already installed, please continue... "
		fi
	fi
}


# --- run application
# $1 : number of args (scripts)
launch() 
{
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	local num_args=$1
	if [ $num_args == 0 ]
	then
		usage
	else 
		build_app
	fi
}

build_app()
{
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	if [ $SJ_PATH_PSDKRA == "/ti/j7/workarea" ];then
		local pdk_package_name=`ls  $SJ_PATH_PSDKRA | grep pdk_ `
		echo_log "- pdk_package_name=$pdk_package_name"
		echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: update the pdk path" 
		
		sed -i "/^PDK_INSTALL_PATH    ?=/c PDK_INSTALL_PATH    ?=\$(PSDK_INSTALL_PATH)/$pdk_package_name/packages"  $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/makerules/config.mk 
		sed -i "/^PSDK_INSTALL_PATH ?=/c PSDK_INSTALL_PATH    ?=$SJ_PATH_PSDKRA/"  $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/makerules/config.mk 
		# PDK_INSTALL_PATH    ?=$(PSDK_INSTALL_PATH)\pdk\packages
		echo " - please run: make tidl-src-addon-package "
	else 
		sed -i "/^PSDK_INSTALL_PATH ?=/c PSDK_INSTALL_PATH    ?=$SJ_PATH_PSDKRA/"  $SJ_PATH_PSDKRA/tidl_${SJ_SOC_TYPE}_$VERSION/makerules/config.mk
		echo "- no need to update"
	fi	

}


# Starting to run
echo "[ $(date) $0] start---"
# Current Dictionary name : 
cwd_c=`dirname $0`
cwd=`pwd`/$cwd_c
echo_log "[ $(date) ] >>> running dictionary:  $cwd" 
check_args $1
update_args_value $*
# parse_args $1
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------