#!/bin/bash
#############################################################################################
# This script is using for configuring the Ubuntu                                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-23 
# @update : fredy  V1                                                                       # 
##############################################################################################


VALID_ARGS=(--list -l --help -h --install -i)
# LOG _LEVEL: debug or no
LOG_LEVEL=debug

# variable : 
INSTALL_NAME=""

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
	--install | -i          config the components

	Optional options:(not used now)
	--sdk                 Path to SDK directory
	--version             Print version.
	--help                Print this help message.

	Config name: 
	- install_openssl_test
	- install_ubuntu_basic
"
}

# --- check the arguments
check_args()
{
	# TODO : modification the files. 
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
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
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 

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
			"--install" | "-i")
				get_arg_value INSTALL_NAME $# $args $args_list
				echo_log "-----INSTALL_NAME: $INSTALL_NAME"
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

install_openssl_test()
{  
	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	sudo apt install openssl
	echo_log "1) Generate RSA key:"
    openssl genrsa -out key.pem 1024 
    openssl rsa -in key.pem -text -noout 
	echo_log "2) Save public key in pub.pem file:"
    openssl rsa -in key.pem -pubout -out pub.pem 
    openssl rsa -in pub.pem -pubin -text -noout 
	echo_log "3) Encrypt some data:"
	echo test test test > file.txt 
	openssl rsautl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
	echo_log "4) Decrypt encrypted data:"
	openssl rsautl -decrypt -inkey key.pem -in file.bin 
	rm file.bin file.txt key.pem pub.pem
}
# solve the ubuntu hang up that can't connect the PC.  
# install-openssl-test()
# {
# 	echo_log "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
# 	sudo apt install openssl
# 	echo_log "1) Generate RSA key:"
#     openssl genrsa -out key.pem 1024 
#     openssl rsa -in key.pem -text -noout 
# 	echo_log "2) Save public key in pub.pem file:"
#     openssl rsa -in key.pem -pubout -out pub.pem 
#     openssl rsa -in pub.pem -pubin -text -noout 
# 	echo_log "3) Encrypt some data:"
# 	echo test test test > file.txt 
# 	openssl rsautl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
# 	echo_log "4) Decrypt encrypted data:"
# 	openssl rsautl -decrypt -inkey key.pem -in file.bin 
# 	# rm file.bin file.txt key.pem pub.pem
# }

# install ubuntu basic 
install_ubuntu_basic()
{
	sudo apt install vim git repo wget curl gitk dialog 
	sudo dpkg --add-architecture i386
	sudo apt update
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
		$INSTALL_NAME
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


