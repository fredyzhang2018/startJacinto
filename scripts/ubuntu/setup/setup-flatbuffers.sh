#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-24                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################

VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p )

# LOG _LEVEL: debug or no
LOG_LEVEL=no

# variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/sdks/
VERSION="1.12.0"
APP_DOWNLOAD_URL="https://github.com/google/flatbuffers.git"
APP_DOWNLOAD_URL1="https://github.com/google/flatbuffers/archive/refs/tags/v$VERSION.tar.gz"
SETUP_YES_NO="no"

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

More details , please visit : https://github.com/google/flatbuffers/releases
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
	if [ $APP_INSTALL_PATH == "" ];then
		echo "- please set the INSTALL_PATH"
		exit 1
	else 
		if [ ! -d $APP_INSTALL_PATH ];then
		echo "- the path is not exist!"
		exit 1
		fi
	fi
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
			setup_src_app
			update_packge_to_target_dictionary
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -i yes to setup" 
		fi
	fi
}

setup_release_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	# setup the package. 
	if [ !  -d $APP_INSTALL_PATH/flatbuffers-`echo "v1.12.0" | sed 's/v//g'` ];then
		cd $APP_INSTALL_PATH && wget $APP_DOWNLOAD_URL
		cd $APP_INSTALL_PATH && tar -zxvf $VERSION.tar.gz
	else 
		echo_log "- Already setup. please continuing ---"
	fi
}

setup_src_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 0 args --- $#" 
	sudo apt-get install autoconf automake libtool curl make g++ unzip
	# setup repo.
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 1. setup the repo"
	
	if [ -d $REPO_INSTALL_PATH ];then
		# clone protobuf
		cd $REPO_INSTALL_PATH && git clone $APP_DOWNLOAD_URL
	fi
	# update branch
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 2. update the branch"
	cd $REPO_INSTALL_PATH/flatbuffers && git checkout v$VERSION
	cd $REPO_INSTALL_PATH/flatbuffers && git log -1 | grep $VERSION
	cd $REPO_INSTALL_PATH/flatbuffers && cmake -G "Unix Makefiles" -DCMAKE_POSITION_INDEPENDENT_CODE=ON 
	cd $REPO_INSTALL_PATH/flatbuffers && make -j$(CPU_NUM)
	# cd $REPO_INSTALL_PATH/protobuf && ./autogen.sh
	# #   # build
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 3. build"
	# cd $REPO_INSTALL_PATH/protobuf && ./configure
	# cd $REPO_INSTALL_PATH/protobuf && make -j$(nproc) # $(nproc) ensures it uses all cores for compilation
	# cd $REPO_INSTALL_PATH/protobuf && make check
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 4. instal"
	# cd $REPO_INSTALL_PATH/protobuf && sudo make install
	# cd $REPO_INSTALL_PATH/protobuf && sudo ldconfig # refresh shared library cache.
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 4. install done"
}

update_packge_to_target_dictionary()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	# setup the package. 
	if [ !  -L $APP_INSTALL_PATH/flatbuffers-$VERSION ];then
		ln -s  $REPO_INSTALL_PATH/flatbuffers $APP_INSTALL_PATH/flatbuffers-$VERSION
	else 
		echo_log "- Already updated. please continuing ---"
	fi
}
# Starting to run
echo "[ $(date) $0] start---"
# Current Dictionary name : 
cwd_c=`dirname $0`
cwd=`pwd`/$cwd_c
echo_log "[ $(date) ] --- running dictionary:  $cwd" 
check_args $*
update_args_value $*
parse_args $1
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------