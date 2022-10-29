#!/bin/bash
#############################################################################################
# This script is using for configuring the Ubuntu                                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-18 
# @update : fredy  V1                                                                       # 
##############################################################################################

VALID_ARGS=(--list -l --help -h --config -c)
# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# variable : 
CONFIG_NAME=""

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
echo " Usage: $0 <options> [ config name ]
	# $0 - To print help infomation
	# $0 --list      |  -l   : list the help infomation 
	# $0 --help      |  -h   : print help infomation.
	# $0 --config    |  -c   : config name 
	Mandatory options:
	--config | -c          config the components

	Optional options:
	--sdk                 Path to SDK directory
	--version             Print version.
	--help                Print this help message.

	Config name: 
	- laptop_mode_set 
	- edid_checking
"
}

# --- check the arguments
check_args()
{
	# TODO : modification the files. 
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
			"--config" | "-c")
				get_arg_value CONFIG_NAME $# $args $args_list
				echo_log "-----CONFIG_NAME: $CONFIG_NAME"
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
# solve the ubuntu hang up that can't connect the PC.  
laptop_mode_set()
{
	# local test_setup=`dpkg -l | grep laptop-mode-tools`
	# if [ -z "$test_setup" ]
	# then
	# 	sudo apt-get install laptop-mode-tools
	# fi
	# local laptop_mode=`cat /proc/sys/vm/laptop_mode`
	# if [ "$test_setup" == "0" ]
	# then
	# 	echo "0 "
	# fi
	# if [ -f /etc/laptop-mode/laptop-mode.conf ]
	# then
	# 	sudo sed -i '/^ENABLE_LAPTOP_MODE_ON_BATTERY/c ENABLE_LAPTOP_MODE_ON_BATTERY=1' /etc/laptop-mode/laptop-mode.conf
	# 	sudo sed -i '/^ENABLE_LAPTOP_MODE_ON_AC/c ENABLE_LAPTOP_MODE_ON_AC=1' /etc/laptop-mode/laptop-mode.conf
	# 	sudo sed -i '/^ENABLE_LAPTOP_MODE_WHEN_LID_CLOSED/c ENABLE_LAPTOP_MODE_WHEN_LID_CLOSED=1' /etc/laptop-mode/laptop-mode.conf
	# 	echo "please check the config: /etc/laptop-mode/laptop-mode.conf"
	# fi 
	# # restart the laptop mode 
	# sudo laptop_mode start
	# cat /proc/sys/vm//laptop_mode
	# 电脑合盖不休眠设置, tested works well. 
	if [ -f /etc/systemd/logind.conf ]
	then
		sudo sed -i '/^#HandleLidSwitch=/c HandleLidSwitch=ignore' /etc/systemd/logind.conf
		echo "please check the config: /etc/systemd/logind.conf  HandleLidSwitch"
		cat /etc/systemd/logind.conf | grep HandleLidSwitch
	fi 
	service systemd-logind restart
}

# edid checking 
edid_checking()
{
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	sudo apt-get install read-edid
	sudo get-edid > myedid.bin
	parse-edid < myedid.bin
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
		$CONFIG_NAME
	fi
}

# Starting to run
echo "[ $(date) $0] start---"
check_args $1
update_args_value $*
parse_args $1
# Launch the application:  $1 : number of args
launch $# 

echo "[ $(date) $0] done!!!"
#---------------------------------------------------------------------------
