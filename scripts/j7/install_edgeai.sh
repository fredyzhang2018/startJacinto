#!/bin/bash
#############################################################################################
# This script is using for edgeai environment setup                       #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2023-03-27                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --soctype -t --validate -b --model  -m  --running  -r --name  -n  --tidl -l  --cxx  -c --ver  -e  --gpu  -g)

# LOG _LEVEL:  0 (error), 1 (info) , 2(debug) , 3 (debug_plus)
LOG_LEVEL=1

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
GPU_SUPPORT="no"
TIDL="no"
CXX_APP="no"
EDGE_VERSION=""
# PROXY_YES="proxychains"
PROXY_YES=""
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
	--install | -i           : default no, set yes
	--soctype | -t           : j721e; j721s2 or j784s4 (Default : $SOC_TYPE )
	--validate | -b          : no or yes
	--model   | -m           : model type onnx tflite
	--running | -r           : run {model type}
	--name    | -n          : model name
	--tidl           : tidl accelate
	--cxx    | -c          : model name
	--ver    | -e          : edgeai tag version 
	--gpu    | -g         :  GPU support 
More details , please visit : xxx
"
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
				LOG_LEVEL="3"
				sh_log debug_plus "--- -v LOG_LEVEL: $LOG_LEVEL"
				;;
			"--soctype" | "-t")
				sh_get_arg_value SOC_TYPE $# $args $args_list
				sh_log debug_plus "--- -t SOC_TYPE: $SOC_TYPE"
				;;
			"--install" | "-i")
				sh_get_arg_value SETUP_YES_NO $# $args $args_list
				sh_log debug_plus "--- -i SETUP_YES_NO: $SETUP_YES_NO"
				;;
			"--validate" | "-b")
				sh_get_arg_value VALIDATE_YES_NO $# $args $args_list
				sh_log debug_plus "--- -b VALIDATE_YES_NO: $VALIDATE_YES_NO"
				;;
			"--path" | "-p")
				sh_get_arg_value APP_INSTALL_PATH $# $args $args_list
				sh_log debug_plus "--- -p APP_INSTALL_PATH: $APP_INSTALL_PATH"
				;;
			"--running" | "-r")
				sh_get_arg_value RUNNING_YES_NO $# $args $args_list
				sh_log debug_plus "--- -r RUNNING_YES_NO: $RUNNING_YES_NO"
				;;
			"--model" | "-m")
				sh_get_arg_value MODEL_TYPE $# $args $args_list
				sh_log debug_plus "--- -m MODEL_TYPE: $MODEL_TYPE"
				;;
			"--name" | "-n")
				sh_get_arg_value MODEL_NAME $# $args $args_list
				sh_log debug_plus "--- -n MODEL_NAME: $MODEL_NAME"
				;;
			"--tidl" | "-l")
				TIDL="yes";
				sh_log debug_plus "--- -l TIDL: $TIDL"
				;;
			"--cxx" | "-c")
				sh_get_arg_value CXX_APP $# $args $args_list
				sh_log debug_plus "--- -c CXX_APP: $CXX_APP"
				;;		
			"--ver" | "-e")
				sh_get_arg_value EDGE_VERSION $# $args $args_list
				sh_log debug_plus "--- -e EDGE_VERSION: $EDGE_VERSION"
				;;		
			"--gpu" | "-g")
				sh_get_arg_value GPU_SUPPORT $# $args $args_list
				sh_log debug_plus "--- -e GPU_SUPPORT: $GPU_SUPPORT"
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
	sh_log info "${FUNCNAME[0]}: args --- $#" 
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

	sh_log info "${FUNCNAME[0]}: args --- $#" 
	local num_args=$1
	if [ $num_args == 0 ]
	then
		usage
	else 
		sh_log debug "${FUNCNAME[0]}: args --- $SETUP_YES_NO" 
		if [ $SETUP_YES_NO == "yes" ];then
			setup_edgeai_tools
		else
			sh_log warning "${FUNCNAME[0]}: please use -i yes to setup" 
		fi
		sh_log debug_plus "${FUNCNAME[0]}: args ---VALIDATE_YES_NO  $VALIDATE_YES_NO" 
		if [ $VALIDATE_YES_NO == "yes" ];then
			validate_benchmark_examples
		else
			sh_log warning "${FUNCNAME[0]}: please use -d yes to validate the dataset" 
		fi
		sh_log debug "${FUNCNAME[0]}: args ---RUNNING_YES_NO  $RUNNING_YES_NO  ---CXX_APP $CXX_APP" 
		if [ $RUNNING_YES_NO == "yes" ];then
			if [ $CXX_APP == "yes" ];then
				Running_model_examples_cxx $MODEL_TYPE
			else 
				Running_model_examples_python
			fi
		else
			sh_log error "[ $(date) ] --- ${FUNCNAME[0]}: please use -r yes to run the demo , setting the MODEL_TYPE" 
		fi
	fi
}

setup_edgeai_tools()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. install the dependent lib:" 
	sudo apt-get install libyaml-cpp-dev
	sh_log debug "1. install the dependent lib -- done" 
	sh_log debug "2. install the edgeai tidl tools code: $SJ_PATH_SDK/edgeai-tidl-tools " 
	if [ -d  $SJ_PATH_SDK/edgeai-tidl-tools ];then
		sh_log info "--- already exist, skipping downloading......"
	else 
		cd $SJ_PATH_SDK && git clone https://github.com/TexasInstruments/edgeai-tidl-tools.git 
	fi
	sh_log debug "2. install the edgeai tidl tools code --done !" 	
	sh_log debug "3. setup for $SOC_TYPE : Supported SOC name strings am62 am62a am68a-J721s2 am68pa-TDA4VM am69a-J784s4"
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		sh_log error “unsupport this soctype, pls check ”
		exit 1
	fi
	#  updating the resources
	sh_log info "$RED============================$YEL input selection $RED==========================$RES"
	read -p "Enter "y" to continue to update the souce - any other character to abort: " confirm;
	sh_log info "$RED============================$YEL input selection $RED==========================$RES -- done!"
	if [ "$confirm" != y ]; then 
		sh_log error "Aborting"; exit 1;
	else 
		sh_log debug "3.1 updating the source ......" 
		cd $SJ_PATH_SDK/edgeai-tidl-tools && git reset --hard && $PROXY_YES git pull origin master
		sh_log debug "3.1 updating the source ...... done!" 
	fi;
	# checkout the new tag. 
	sh_log info "$RED============================$YEL input selection $RED==========================$RES"
	sh_log info "$PUR TIDL PSDKRA BRANCH:      $SJ_PSDKRA_BRANCH"
	sh_log info "$PUR TIDL PSDKRA USER DEFINE: $EDGE_VERSION"
	read -p '--- Enter "y" to update default PSDKRA \
--- Enter "d" to update USER tag.   \
--- Any other character to abort: ' confirm;
	sh_log info "$RED============================$YEL input selection $RED==========================$RES -- done!"
	if [ "$confirm" == y ]; then 
		sh_log debug "3.2 updating PSDKRA Default $SJ_PATH_SDK/edgeai-tidl-tools tag: $SJ_PSDKRA_BRANCH" 
		cd $SJ_PATH_SDK/edgeai-tidl-tools && git checkout $SJ_PSDKRA_BRANCH
		sh_log debug "3.2 updating PSDKRA Default $SJ_PATH_SDK/edgeai-tidl-tools tag: $SJ_PSDKRA_BRANCH --done!" 
	elif [ "$confirm" == d ]; then
		sh_log debug "3.2 updating USER DEF $SJ_PATH_SDK/edgeai-tidl-tools tag: $EDGE_VERSION" 
		cd $SJ_PATH_SDK/edgeai-tidl-tools && git checkout $EDGE_VERSION
		sh_log debug "3.2 updating  USER DEF $SJ_PATH_SDK/edgeai-tidl-tools tag: $EDGE_VERSION --done!" 
	else 
		sh_log error "Aborting"; exit 1;
	fi;

	# Setup the additional packages. 
	sh_log info "$RED============================$YEL input selection $RED==========================$RES"
	read -p '--- Enter "1" first time to setup the environment.  \
--- Enter "2" to setup by skiping skip_arm_gcc_download  \
--- Enter "3" to setup by using the SDK tidl_tool \
--- Enter "4" to setup by skip_cpp_deps and skip_arm_gcc_download \
--- Enter "5" to setup by using the SDK tidl_tool + skip_cpp_deps and skip_arm_gcc_download\
--- Any other character to abort: ' confirm;
	sh_log info "$RED============================$YEL input selection $RED==========================$RES -- done!"
	if [ "$confirm" == 1 ]; then 
		sh_log debug "3.2 setup all the environment...  " 
		export SOC=$SOC_TYPE_TEMP && cd $SJ_PATH_SDK/edgeai-tidl-tools && source $PROXY_YES ./setup.sh
		sh_log debug "3.2 setup all the environment...  done! " 
	elif [ "$confirm" == 2 ]; then
		sh_log debug " 3.2 setup by skipping the compile ... " 
		#export ARM64_GCC_PATH=/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
		export SOC=$SOC_TYPE_TEMP
		export ARM64_GCC_PATH=$HOME/ti/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu 
		if [ $GPU_SUPPORT == "yes" ];then
			sh_log help "GPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=GPU 
		else
			sh_log help "CPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=cpu 
		fi
		cd $SJ_PATH_SDK/edgeai-tidl-tools && source $PROXY_YES ./setup.sh --skip_arm_gcc_download
		sh_log debug "3.2 setup by skipping the compile ... done!"
	elif [ "$confirm" == 3 ]; then
		sh_log debug "3.2 setup by using the SDK tidl_tool ... $SJ_PATH_PSDKRA" 
		export SOC=$SOC_TYPE_TEMP
		export TIDL_TOOLS_PATH=$SJ_PATH_PSDKRA/c7x-mma-tidl/tidl_tools
		if [ $GPU_SUPPORT == "yes" ];then
			sh_log help "GPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=GPU 
		else
			sh_log help "CPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=cpu 
		fi
		cd $SJ_PATH_SDK/edgeai-tidl-tools && source $PROXY_YES ./setup.sh --skip_arm_gcc_download 
		sh_log debug "3.2 setup by skipping the compile ... done!" 
	elif [ "$confirm" == 4 ]; then
		sh_log debug "3.2 setup by using the SDK tidl_tool ... done! " 
		export SOC=$SOC_TYPE_TEMP
		if [ $GPU_SUPPORT == "yes" ];then
			sh_log help "GPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=GPU 
		else
			sh_log help "CPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=cpu 
		fi
		cd $SJ_PATH_SDK/edgeai-tidl-tools && source $PROXY_YES ./setup.sh --skip_cpp_deps --skip_arm_gcc_download
		sh_log debug "3.2 setup by skipping cpp deps ... done!" 
	elif [ "$confirm" == 5 ]; then
		sh_log debug "3.2 setup by using the SDK tidl_tool ... $SJ_PATH_PSDKRA" 
		export SOC=$SOC_TYPE_TEMP
		export TIDL_TOOLS_PATH=$SJ_PATH_PSDKRA/c7x-mma-tidl/tidl_tools
		if [ $GPU_SUPPORT == "yes" ];then
			sh_log help "GPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=GPU 
		else
			sh_log help "CPU --- TIDL_TOOLS_TYPE","$TIDL_TOOLS_TYPE"
			export TIDL_TOOLS_TYPE=cpu 
		fi
		cd $SJ_PATH_SDK/edgeai-tidl-tools && source $PROXY_YES ./setup.sh --skip_arm_gcc_download --skip_cpp_deps 
		sh_log debug "3.2 setup by skipping the compile ... done!" 
	else 
		sh_log error "Aborting"; exit 1;
	fi;
	sh_log debug  "3. install the edgeai tidl tools code --done !"
}

validate_benchmark_examples()
{
	sh_log debug  "${FUNCNAME[0]}: args --- $#" 
	sh_log debug  "1. Validate and Benchmark out-of-box examples" 
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		sh_log error “unsupport this soctype, pls check ”
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
	sh_log debug  "1. Validate and Benchmark out-of-box examples --done " 
	sh_log debug  "2. check the result:  " 
	sh_log debug  "$SJ_PATH_SDK/edgeai-tidl-tools/model-artifacts/"
	sh_log debug  "$SJ_PATH_SDK/edgeai-tidl-tools/models/"
	sh_log debug  "$SJ_PATH_SDK/edgeai-tidl-tools/output_images/"
	esh_log debug  "$SJ_PATH_SDK/edgeai-tidl-tools/test_report_pc_$SOC_TYPE_TEMP.csv"
	sh_log debug  "2. check the result --done " 
}

Running_model_examples_cxx()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. Inference using Cxx app. " 
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		sh_log error “unsupport this soctype, pls check ”
		exit 1
	fi
	export SOC=$SOC_TYPE_TEMP
	cd $SJ_PATH_SDK/edgeai-tidl-tools
	export TIDL_TOOLS_PATH=$(pwd)/tidl_tools
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TIDL_TOOLS_PATH
	export ARM64_GCC_PATH=$(pwd)/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
	sh_log debug "2. inference ... : $MODEL_NAME-$MODEL_TYPE" 
	if [ $MODEL_TYPE == "tflite" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools/build/bin/Release/tfl_main TIDL $TIDL" 
		if [ $TIDL == "yes" ]; then 
			cd $SJ_PATH_SDK/edgeai-tidl-tools/ && ./bin/Release/tfl_main  -a 1 -f model-artifacts/$MODEL_NAME-$MODEL_TYPE  -i test_data/airshow.jpg
		else
			cd $SJ_PATH_SDK/edgeai-tidl-tools/ && ./bin/Release/tfl_main -f model-artifacts/$MODEL_NAME-$MODEL_TYPE  -i test_data/airshow.jpg
		fi
	elif [ $MODEL_TYPE == "onnx" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools/build/bin/Release/ort_main  TIDL $TIDL" 
		if [ $TIDL == "yes" ]; then 
			echo " tidl accelerate ... "
			cd $SJ_PATH_SDK/edgeai-tidl-tools/ && ./bin/Release/ort_main  -a 1 -f model-artifacts/$MODEL_NAME-$MODEL_TYPE  -i test_data/airshow.jpg -v 1
		else
			cd $SJ_PATH_SDK/edgeai-tidl-tools/ && ./bin/Release/ort_main -f model-artifacts/$MODEL_NAME-$MODEL_TYPE  -i test_data/airshow.jpg -v 1
		fi
	else 
		sh_log error “unsupport this soctype, pls check ”
		exit 1
	fi
	sh_log debug "-------------------------------------------------------------------------------------------------"
	cd $SJ_PATH_SDK/edgeai-tidl-tools/ && ls -l ./output_images/cpp_out_$MODEL_NAME-$MODEL_TYPE*
	sh_log debug "-------------------------------------------------------------------------------------------------"
	sh_log debug "2.  inference ... : $MODEL_NAME-$MODEL_TYPE --done!!!" 
}


Running_model_examples_python()
{
	sh_log debug "${FUNCNAME[0]}: args --- $#" 
	sh_log debug "1. Validate and Benchmark out-of-box examples" 
	if [ $SOC_TYPE == "j721e" ];then
		SOC_TYPE_TEMP=am68pa;
	elif [ $SOC_TYPE == "j721s2" ];then
		SOC_TYPE_TEMP=am68a;
	elif [ $SOC_TYPE == "j784s4" ];then
		SOC_TYPE_TEMP=am69a;
	else 
		sh_log error “unsupport this soctype, pls check ”
		exit 1
	fi
	export SOC=$SOC_TYPE_TEMP
	cd $SJ_PATH_SDK/edgeai-tidl-tools
	export TIDL_TOOLS_PATH=$(pwd)/tidl_tools
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TIDL_TOOLS_PATH
	export ARM64_GCC_PATH=$(pwd)/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
	sh_log debug "2.  Model Compilation : $MODEL_TYPE" 
	if [ $MODEL_TYPE == "tflite" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools//examples/osrt_python/tfl/tflrt_delegate.py " 
		cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl;
		python3 tflrt_delegate.py -c -m $MODEL_NAME-$MODEL_TYPE;
	elif [ $MODEL_TYPE == "onnx" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort/onnxrt_ep.py " 
		cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort;
		python3 onnxrt_ep.py -c -m $MODEL_NAME-$MODEL_TYPE;
	else 
		sh_log error “unsupport this soctype, pls check ”
		exit 1
	fi
	sh_log debug "2.  Model Compilation --done!!!" 
	sh_log debug "3.  Model Inference on PC:" 
	sh_log debug "3.1  Run Inference on PC using TIDL artifacts generated during compilation, using -d to  Run Inference on PC without TIDL offload TIDL_ACC = $TIDL_ACC" 
	if [ $MODEL_TYPE == "tflite" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/tflrt_delegate.py TIDL = $TIDL" 
		if [ $TIDL == "no" ];then
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/ && python3 tflrt_delegate.py -d -m $MODEL_NAME-$MODEL_TYPE
		else 
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/tfl/ && python3 tflrt_delegate.py -m $MODEL_NAME-$MODEL_TYPE
		fi
	elif [ $MODEL_TYPE == "onnx" ];then
		sh_log debug "path: $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort/onnxrt_ep.py TIDL =$TIDL " 
		if [ $TIDL == "no" ];then
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort && python3 onnxrt_ep.py -d -m $MODEL_NAME-$MODEL_TYPE;
		else 
			cd $SJ_PATH_SDK/edgeai-tidl-tools/examples/osrt_python/ort && python3 onnxrt_ep.py -m $MODEL_NAME-$MODEL_TYPE;
		fi
	else 
		sh_log error “unsupport this soctype, pls check !”
		exit 1
	fi
	sh_log debug "3.  Model Inference on PC: -- done" 
}


# Starting to run
# common_ubuntu_test

sh_log info "[ $0 ] start... "
sh_log file "runnig scripts" "$0"
# Current Dictionary name : 
sh_get_dirtionary_name cwd_c
sh_log debug "running dictionary:  ./$cwd_c" 

# check the args
sh_check_args $*

# update the args
update_args_value $*
# --------------------------------------------------------------------------------------------------------------------------------
# - package link URL and data link URL1 
# APP_DOWNLOAD_URL="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION.tar.gz" # github repo
# APP_DOWNLOAD_URL1="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/psdk_rtos_ti_data_set_`echo $VERSION | cut -c 1-8`.tar.gz"
# APP_DOWNLOAD_URL2="https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$VERSION/exports/ti-processor-sdk-rtos-j721e-evm-$VERSION-prebuilt.tar.gz"
if [ $SJ_SOC_TYPE == "j721e" ];then
	LINK_ADDR="MD-bA0wfI4X2g"
	sh_log debug " ==> - link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
elif [ $SJ_SOC_TYPE == "j721s2" ];then
	LINK_ADDR="MD-50weZVBfzl"
	sh_log debug " ==> - link_addr:  $SJ_SOC_TYPE $LINK_ADDR"
else 
	sh_log error " not support , pls check LINK_ADDR... "; 
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
sh_log info "[ $0 ] ==> done   !!!"
#---------------------------------------------------------------------------
