#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-03-19                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --launch -l  --PATH  -p )

# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/sdks/
VERSION="7.13.5"
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

More details , please visit : https://www.postgresql.org/
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
				# get_arg_value APP_INSTALL_PATH $# $args $args_list
				# echo_log "--- -p APP_INSTALL_PATH: $APP_INSTALL_PATH"
				;;
			"--launch" | "-l")
				echo "add later"
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
	USER_HOME=/home/`whoami`
	echo "- check the paths: REPO_INSTALL_PATH SJ_PATH_DOWNLOAD USER_HOME"
	for T_PATH in $REPO_INSTALL_PATH $SJ_PATH_DOWNLOAD $USER_HOME
	do
		if [ $T_PATH == "" ];then
			echo "-- please set the $T_PATH path"
			exit 1
		else 
			if [ ! -d $T_PATH ];then
				echo "-- the path is not exist!"
				exit 1
			else 
				echo "-- $T_PATH PATH is exist!"
			fi
		fi
	done
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
			# setup_release_app
			setup_app
		else
			echo_log "[ $(date) ] --- ${FUNCNAME[0]}: please use -i yes to setup" 
		fi
	fi
}


setup_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 0 args --- $#" 
	echo ""
	echo_log "- step1 : install on ubuntu "
	# sudo apt update
	sudo apt install postgresql=13.4 postgresql-contrib=13.4  --reinstall
	
	echo_log "- step2 : check the database postgresql status "
	service postgresql status
    echo_log "- step3 : check the database postgresql port "
	sudo cat /etc/postgresql/10/main/postgresql.conf  | grep port
	echo_log "- step4 : check the remote login /etc/postgresql/10/main/postgresql.conf"
	sudo cat /etc/postgresql/10/main/postgresql.conf | grep listen_addresses
	sudo cat /etc/postgresql/10/main/pg_hba.conf | grep host
	T_REMOTE=`sudo cat /etc/postgresql/10/main/postgresql.conf | grep listen_addresses | cut -c 1-3`
	echo_log "- $T_REMOTE"
	if [ $T_REMOTE == "#li" ];then 
		echo_log "- please enable the remote login"
	else 
		echo_log "- already enable the remote login"
	fi
	echo_log "- step5 : enable the port for external access"
	sudo ufw allow 8090 
	sudo ufw allow 8091 
	sudo ufw allow 8000 
	echo_log "- step6 : mannually set the database"
	echo_log "- step7 : ---setup done !!! "
	
	# if [ ! -f $SJ_PATH_DOWNLOAD/atlassian-confluence-$VERSION.tar.gz ];then
	# 	echo_log "--   please install the docker first. Thanks. "
	# 	cd $SJ_PATH_DOWNLOAD && wget $APP_DOWNLOAD_URL
	# else
	# 	echo_log "--   image already , continuing >>> " 
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
parse_args
#-------------------------------------------------------------------------------------------------------------------------
APP_DOWNLOAD_URL="https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-$VERSION-x64.bin" # github repo
APP_DOWNLOAD_URL1="https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-$VERSION.tar.gz"
#-------------------------------------------------------------------------------------------------------------------------
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
