#!/bin/bash
#############################################################################################
# This script is using for configuring the Ubuntu                                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-23 
# @update : fredy  V1                                                                       # 
##############################################################################################
VALID_ARGS=(--list -l --help -h --install -i)

# LOG _LEVEL:  0 (error), 1 (info) , 2(debug) , 3 (debug_plus)
LOG_LEVEL=3
# including common tools. 
. $SJ_PATH_JACINTO/scripts/ubuntu/common_ubuntu.sh


# variable : 
INSTALL_NAME=""

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


# update args value
# $1 : $*
update_args_value()
{
	# loop args and set the variable
	args_list=$* 
	sh_log info "$0 Argslist: $args_list  num:  $# " 

	for args in $args_list
	do 
		sh_log info " args : $args"
		case $args in
			"--list" | "-l")
				usage
				;;
			"--help" | "-h")
				usage
				;;
			"--install" | "-i")
				sh_get_arg_value INSTALL_NAME $# $args $args_list
				sh_log info "-----INSTALL_NAME: $INSTALL_NAME"
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
}

install_openssl_test()
{  
	sh_log info "${FUNCNAME[0]}: args --- $#" 
	sudo apt install openssl
	sh_log info "1) Generate RSA key:"
    openssl genrsa -out key.pem 1024 
    openssl rsa -in key.pem -text -noout 
	sh_log info "2) Save public key in pub.pem file:"
    openssl rsa -in key.pem -pubout -out pub.pem 
    openssl rsa -in pub.pem -pubin -text -noout 
	sh_log info "3) Encrypt some data:"
	echo test test test > file.txt 
	openssl rsautl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
	sh_log info "4) Decrypt encrypted data:"
	openssl rsautl -decrypt -inkey key.pem -in file.bin 
	rm file.bin file.txt key.pem pub.pem
}
# solve the ubuntu hang up that can't connect the PC.  
# install-openssl-test()
# {
# 	sh_log info "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
# 	sudo apt install openssl
# 	sh_log info "1) Generate RSA key:"
#     openssl genrsa -out key.pem 1024 
#     openssl rsa -in key.pem -text -noout 
# 	sh_log info "2) Save public key in pub.pem file:"
#     openssl rsa -in key.pem -pubout -out pub.pem 
#     openssl rsa -in pub.pem -pubin -text -noout 
# 	sh_log info "3) Encrypt some data:"
# 	echo test test test > file.txt 
# 	openssl rsautl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
# 	sh_log info "4) Decrypt encrypted data:"
# 	openssl rsautl -decrypt -inkey key.pem -in file.bin 
# 	# rm file.bin file.txt key.pem pub.pem
# }

# install ubuntu basic 
install_ubuntu_basic()
{
	sh_log info "${FUNCNAME[0]}: args --- $#" 
	sudo apt install vim git repo wget curl gitk dialog 
	sudo apt install snapd
	sudo apt-get install libx11-dev libgl1-mesa-dev libxext-dev perl perl-modules make git
	sudo apt-get install cpufrequtils htop
	sudo dpkg --add-architecture i386
	sudo apt update
	sudo apt install git-lfs lib32ncurses6 lib32z1 unzip
	sh_log info "${FUNCNAME[0]}: args --- $# done!" 
}

# --- run application
# $1 : number of args (scripts)
launch() 
{
	sh_log info "[ $(date) ] >>> ${FUNCNAME[0]}: args --- $#" 
	local num_args=$1
	if [ $num_args == 0 ]
	then
		usage
	else 
		$INSTALL_NAME
	fi
}

# Starting to run
sh_log info "[ $(date) $0] start---"
sh_check_args $1
update_args_value $*
parse_args $1
# Launch the application:  $1 : number of args
launch $# 
sh_log info "[ $(date) $0] start--- done!"
#---------------------------------------------------------------------------


