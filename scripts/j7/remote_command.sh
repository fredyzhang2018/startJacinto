#!/bin/sh
#############################################################################################
# This script is using for running the command on remote machine.                           #
#     You should make sure you can login the remote shell without password.     
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-16                                                                      # 
##############################################################################################

VALID_ARGS=(--list -l --help -h --ip)
# LOG _LEVEL: debug or no
LOG_LEVEL=debug
echo_log()
{
	if [ $LOG_LEVEL == "debug" ]; then
		echo $1
	fi
}
# --- usage introduction. 
usage()
{
	echo "[ $(date) ] >>> # $0 - To launch the startJacinto tools"
	echo "[ $(date) ] >>> # $0 --list  | -l - To list all the supported SDKs Selections"
	echo "[ $(date) ] >>> # $0 --help  | -h - To display this"
	echo "[ $(date) ] >>> # $0 --ip  command - To set the IP "
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

launch()
{
# $1 :IP 
# $2 : scripts
echo_log "[ $(date) ] >>> launch the application: IP and COMMAND : $1 `pwd`/$2 >>>" 
#ssh root@$1 "cd /home/; ls "
COMMANDS=`cat $2`
ssh root@$1 /bin/bash << remotessh
$COMMANDS
remotessh
}

# Starting to run
check_args $1
parse_args $1
case $1 in
	"--list" | "-l")
		usage
		;;
	"--help" | "-h")
		usage
		;;
	"--ip"         )
		launch $2 $3
		;;
	"")
		usage
		;;
esac
echo_log "[ $(date) ] >>> $0 done   !!!" 
#---------------------------------------------------------------------------
