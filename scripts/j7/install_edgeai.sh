#!/bin/bash
#############################################################################################
# This script is using for edgeai environment setup                       #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2023-03-27                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --soctype -t --validate -b --model  -m  --running  -r --name  -n  --tidl -l  )

# LOG _LEVEL: debug or no
LOG_LEVEL=no

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/downloads/
SETUP_YES_NO="no"
VALIDATE_YES_NO="no"
CPU_NUM=`nproc`
SOC_TYPE="j721e"
RUNNING_YES_NO="no"
MODEL_TYPE="no"
MODEL_NAME="no"
TIDL="no"

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
	--install | -i           : default no, set yes
	--soctype | -t           : j721e; j721s2 or j784s4 (Default : $SOC_TYPE )
	--validate | -b          : no or yes
	--model   | -m           : model type onnx tflite
	--running | -r           : run {model type}
	--name    | -n          : model name
	--tidl           : tidl accelate
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
		echo_log "- get_arg_value:  check : $i $3 `eval echo "$"{$i}""`"
		if [ `eval echo "$"{$i}""` == $ArgsFlag  ] 
		then
			echo_log "- get_arg_value: get  $ArgsFlag  `eval echo "$"{$((i+1))}""`"
			eval $_Output="`eval echo "$"{$((i+1))}""`"
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
			"--soctype" | "-t")
					get_arg_value SOC_TYPE $# $args $args_list
					echo_log "--- -t SOC_TYPE: $SOC_TYPE"
				;;
			"--install" | "-i")
					get_arg_value SETUP_YES_NO $# $args $args_list
					echo_log "--- -i SETUP_YES_NO: $SETUP_YES_NO"
					;;
			"--validate" | "-b")
					get_arg_value VALIDATE_YES_NO $# $args $args_list
					echo_log "--- -b VALIDATE_YES_NO: $VALIDATE_YES_NO"
					;;
			"--path" | "-p")
				get_arg_value APP_INSTALL_PATH $# $args $args_list
				echo_log "--- -p APP_INSTALL_PATH: $APP_INSTALL_PATH"
				;;
			"--running" | "-r")
				get_arg_value RUNNING_YES_NO $# $args $args_list
				echo_log "--- -r RUNNING_YES_NO: $RUNNING_YES_NO"
				;;
			"--model" | "-m")
				get_arg_value MODEL_TYPE $# $args $args_list
				echo_log "--- -m MODEL_TYPE: $MODEL_TYPE"
				;;
			"--name" | "-n")
				get_arg_value MODEL_NAME $# $args $args_list
				echo_log "--- -n MODEL_NAME: $MODEL_NAME"
				;;
			"--tidl" | "-l")
				TIDL="yes";
				echo_log "--- -l TIDL: $TIDL"
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
			setup_edgeai_tools
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -i yes to setup" 
		fi
		echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args ---VALIDATE_YES_NO  $VALIDATE_YES_NO" 
		if [ $VALIDATE_YES_NO == "yes" ];then
			validate_benchmark_examples
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -d yes to install the dataset" 
		fi
		echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args ---RUNNING_YES_NO  $RUNNING_YES_NO" 
		if [ $RUNNING_YES_NO == "yes" ];then
			Running_model_examples
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -r yes to run the demo , setting the MODEL_TYPE" 
		fi
	fi
}

setup_edgeai_tools()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	echo_log "[ $(date) ] - 1. install the dependent lib:" 
	apt-get install libyaml-cpp-dev
	echo_log "[ $(date) ] - 1. install the dependent lib -- done" 
	echo_log "[ $(date) ] - 2. install the edgeai tidl tools code: $SJ_PATH_SDK/edgeai-tidl-tools " 
	cd $SJ_PATH_SDK && git clone https://github.com/TexasInstruments/edgeai-tidl-tools.git 
	echo_log "[ $(date) ] - 2. install the edgeai tidl tools code --done !" 	
	echo_log "[ $(date) ] - 3. setup for $SOC_TYPE : Supported SOC name strings am62 am62a am68a-J721s2 am68pa-TDA4VM am69a-J784s4"
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		echo “unsupport this soctype, pls check ”
		exit 1
	fi
	# pull and update the source . 	
	git pull origin
	psdkra_ver=`echo $SJ_PSDKRA_BRANCH |sed  s/_//g | cut -c 2-8`
	if [ $psdkra_ver == "9000002" ];then
		Temp_Tag="09_00_00_06";
		echo "   >>> TIDL tag : PSDKRA: $psdkra_ver (tidl - 09_00_00_06) "
		cd $SJ_PATH_SDK/edgeai-tidl-tools && git checkout master # git checkout $Temp_Tag
	else
		echo "SDK version is not correct , pls check ... "
		exit 1
	fi

	export SOC=$SOC_TYPE_TEMP && cd $SJ_PATH_SDK/edgeai-tidl-tools && source ./setup.sh
	
	echo_log "[ $(date) ] - 3. install the edgeai tidl tools code --done !"
}

validate_benchmark_examples()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	echo_log "[ $(date) ] - 1. Validate and Benchmark out-of-box examples" 
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		echo “unsupport this soctype, pls check ”
		exit 1
	fi
	export SOC=$SOC_TYPE_TEMP
	cd $SJ_PATH_SDK/edgeai-tidl-tools
	export TIDL_TOOLS_PATH=$(pwd)/tidl_tools
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TIDL_TOOLS_PATH
	export ARM64_GCC_PATH=$(pwd)/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
	mkdir build && cd build
	cmake ../examples && make -j && cd ..
	source ./scripts/run_python_examples.sh
	python3 ./scripts/gen_test_report.py
	echo_log "[ $(date) ] - 1. Validate and Benchmark out-of-box examples --done " 
	echo_log "[ $(date) ] - 2. check the result:  " 
	echo_log "$SJ_PATH_SDK/edgeai-tidl-tools/model-artifacts/"
	echo_log "$SJ_PATH_SDK/edgeai-tidl-tools/models/"
	echo_log "$SJ_PATH_SDK/edgeai-tidl-tools/output_images/"
	echo_log "$SJ_PATH_SDK/edgeai-tidl-tools/test_report_pc_$SOC_TYPE_TEMP.csv"
	echo_log "[ $(date) ] - 2. check the result --done " 
}

Running_model_examples()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	echo_log "[ $(date) ] - 1. Validate and Benchmark out-of-box examples" 
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		echo “unsupport this soctype, pls check ”
		exit 1
	fi
	export SOC=$SOC_TYPE_TEMP
	cd $SJ_PATH_SDK/edgeai-tidl-tools
	export TIDL_TOOLS_PATH=$(pwd)/tidl_tools
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TIDL_TOOLS_PATH
	export ARM64_GCC_PATH=$(pwd)/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
	echo_log "[ $(date) ] - 2.  Model Compilation : $MODEL_TYPE" 
	if [ $MODEL_TYPE == "tflite" ];then
		echo_log "[ $(date) ] - path: $SJ_PATH_SDK/edgeai-tidl-tools//examples/osrt_python/tfl/tflrt_delegate.py " 
		cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl;
		python3 tflrt_delegate.py -c -m $MODEL_NAME-$MODEL_TYPE;
	elif [ $MODEL_TYPE == "onnx" ];then
		echo_log "[ $(date) ] - path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort/onnxrt_ep.py " 
		cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort;
		python3 onnxrt_ep.py -c -m $MODEL_NAME-$MODEL_TYPE;
	else 
		echo “unsupport this soctype, pls check ”
		exit 1
	fi
	echo_log "[ $(date) ] - 2.  Model Compilation --done!!!" 
	echo_log "[ $(date) ] - 3.  Model Inference on PC:" 
	echo_log "[ $(date) ] - 3.1  Run Inference on PC using TIDL artifacts generated during compilation, using -d to  Run Inference on PC without TIDL offload TIDL_ACC = $TIDL_ACC" 
	if [ $MODEL_TYPE == "tflite" ];then
		echo_log "[ $(date) ] - path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/tflrt_delegate.py TIDL = $TIDL" 
		if [ $TIDL == "no" ];then
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/ && python3 tflrt_delegate.py -d -m $MODEL_NAME-$MODEL_TYPE
		else 
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/ && python3 tflrt_delegate.py -m $MODEL_NAME-$MODEL_TYPE
		fi
	elif [ $MODEL_TYPE == "onnx" ];then
		echo_log "[ $(date) ] - path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort/onnxrt_ep.py TIDL =$TIDL " 
		if [ $TIDL == "no" ];then
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort && python3 onnxrt_ep.py -d -m $MODEL_NAME-$MODEL_TYPE;
		else 
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort && python3 onnxrt_ep.py -m $MODEL_NAME-$MODEL_TYPE;
		fi
	else 
		echo “unsupport this soctype, pls check ”
		exit 1
	fi
	echo_log "[ $(date) ] - 3.  Model Inference on PC: -- done" 
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
if [ $SJ_SOC_TYPE == "j721e" ];then
	LINK_ADDR="MD-bA0wfI4X2g"
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "j721s2" ];then
	LINK_ADDR="MD-50weZVBfzl"
	echo_log "[ $(date) ] - link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
else 
	echo " not support , pls check LINK_ADDR... "; 
	exit 1
fi
APP_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION.tar.gz" # github repo
APP_DOWNLOAD_URL1="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
APP_DOWNLOAD_URL2="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz"
APP_DOWNLOAD_URL3="https://dr-download.ti.com/software-development/software-development-kit-sdk/$LINK_ADDR/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`_$SJ_SOC_TYPE.tar.gz"
APP_J721S2_DOWNLOAD_URL="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-50weZVBfzl/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION.tar.gz" # github repo
APP_J721S2_DOWNLOAD_URL1="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-50weZVBfzl/`echo $VERSION | sed s/_/./g`/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
APP_J721S2_DOWNLOAD_URL2="https://dr-download.ti.com/software-development/software-development-kit-sdk/MD-50weZVBfzl/`echo $VERSION | sed s/_/./g`/ti-processor-sdk-rtos-$SJ_SOC_TYPE-evm-$VERSION-prebuilt.tar.gz"

# -------------------------------------------------------------------------------------------------------------------------------------
parse_args
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
