#!/bin/sh
#############################################################################################
# This script is using for ? .                                  #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-16                                                                      # 
##############################################################################################

VALID_ARGS=(--list -l --help -h)
# LOG _LEVEL: debug or no
LOG_LEVEL=no
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
	echo_log "[ $(date) ] >>> launch the application >>>" 

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
	"")
		launch
		;;
esac
echo_log "[ $(date) ] >>> $0 done   !!!" 
#---------------------------------------------------------------------------
