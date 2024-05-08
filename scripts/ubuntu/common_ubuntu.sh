#!/bin/sh

# This distribution contains contributions or derivatives under copyright
# as follows:
#
# Copyright (c) 2024, Fredy Zhang : fredyzhang2018@gmail.com
# All rights reserved.

GRE="\\033[0;32m"
YEL="\\033[0;33m"
RED="\\033[0;31m"
BLU="\\033[0;34m"
PUR="\\033[0;35m"
CYA="\\033[0;36m"
RES="\\033[0m"
WHI="\033[0;37m"
RES="\033[0m"
BOLD="\033[1m"
ITAL="\033[3m"
UNDE="\033[4m"

check_status() {
    ret=$?
    if [ "$ret" -ne "0" ]; then
        echo "Failed setup, aborting.."
        exit 1
    fi
}

# This function will return the code name of the Linux host release to the caller
get_host_type() {
    local  __host_type=$1
    local  the_host=`lsb_release -a 2>/dev/null | grep Codename: | awk {'print $2'}`
    eval $__host_type="'$the_host'"
}

# This function returns the version of the Linux host to the caller
sh_get_host_type() {
    local  __host_ver=$1
    local  the_version=`lsb_release -a 2>/dev/null | grep Release: | awk {'print $2'}`
    eval $__host_ver="'$the_version'"
}

# This function returns the major version of the Linux host to the caller
# If the host is version 12.04 then this function will return 12
get_major_host_version() {
    local  __host_ver=$1
    get_host_version major_version
    eval $__host_ver="'${major_version%%.*}'"
}

# This function returns the minor version of the Linux host to the caller
# If the host is version 12.04 then this function will return 04
get_minor_host_version() {
    local  __host_ver=$1
    get_host_version minor_version
    eval $__host_ver="'${minor_version##*.}'"
}


# This function returns current file dirtionary.
# If the host is version 12.04 then this function will return 04
sh_get_dirtionary_name() {
    local  __dir_name=$1
    cwd_now=`dirname $0`
    eval $__dir_name="'${cwd_now##*.}'"
}


#sj_echo_log
# $0 : 0 print 1: log file 2: both 
# $1 : message
sh_log()
{
	case $1 in 
		info) 
           	 if [ $LOG_LEVEL -gt 0 ]; then
			echo -e "${BLU}${BOLD}[SH INFO]${RES} ==> ${BLU}$2 ${RES}"; 
           	 fi 
			echo -e "[ `date` SH INFO ] ==> $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
		;;   
		warning) 
            if [ $LOG_LEVEL -gt 0 ]; then
                echo -e "${YEL}${BOLD}[SH WARNING]${RES} ==> ${YEL}$2 ${RES}"; 
                echo -e "==> SH WARNING >>> $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
            fi
		;;   
		debug) 
            if [ $LOG_LEVEL -gt 1 ]; then
                echo -e "${PUR}${BOLD}[SH DEBUG]${RES} ==> ${PUR}$2 ${RES}"; 
                echo -e "==> SH DEBUG >>> $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
            fi
		;;   
		debug_plus) 
            if [ $LOG_LEVEL -gt 2 ]; then
                echo -e "${PUR}${BOLD}[SH DEBUG_PLUS]${RES} ==> ${PUR}$2 ${RES}"; 
                echo -e " ==> SH DEBUG_PLUS >>> $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
            fi
		;;   
		error)
            		echo -e "${RED}${BOLD}[SH ERROR]${RES} ==> ${RED}$2 ${RES}"; 
			echo -e "==> SH ERROR >>>  $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
		;;   
		critical)
            if [ $LOG_LEVEL -gt 0 ]; then
                echo -e "${RED}${BOLD}[SH CRITICAL]${RES} ==> ${RED}$2 ${RES}"; 
			    echo -e "==> SH CRITICAL >>>  $2"  >> ${SJ_PATH_JACINTO}/.sj_log; 
            fi 
		;;  
		help)
            echo -e "${GRE}${BOLD}[SH HELP]${RES} ==> ${YEL}${BOLD}$2${RES}: ${PUR}${ITAL}$3${RES}"; 
			echo -e "==> SH HELP >>>  $2 $3"  >> ${SJ_PATH_JACINTO}/.sj_log; 
		;;   
		file)
            echo -e "${GRE}${BOLD}[SH FILE/LINK]${RES} ==> ${YEL}${BOLD}$2${RES}: ${PUR}${ITAL}$3${RES}"; 
			echo -e "==> SH FILE/LINK >>>  $2 $3"  >> ${SJ_PATH_JACINTO}/.sj_log; 
		;;   
		*)   
			echo -e "==> SH ERROR ............................................. "; 
		;;   
	esac
}
# --- check the arguments
#   input : args 
sh_check_args()
{
	# TODO : modification the files. 
	sh_log info "${FUNCNAME[0]}: args --- $#" 
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
sh_get_arg_value() 
{
	local _Output=$1
	local ArgsNum=$2
	local ArgsFlag=$3
	local ArgsList=$@
	sh_log debug_plus  "- get_arg_value: ArgsList:  $ArgsList"
	
	for i in $(seq 4 `expr $2 + 2`)
	do
		sh_log debug_plus  "- get_arg_value:  check : $i $3 `eval echo "$"{$i}""`"
		if [ `eval echo "$"{$i}""` == $ArgsFlag  ] 
		then
            sh_log debug "- get_arg_value: get  $ArgsFlag  `eval echo "$"{$((i+1))}""`"
			eval $_Output="`eval echo "$"{$((i+1))}""`"
		fi 
	done
}


common_ubuntu_test()
{

    LOG_LEVEL=3
    # new_dir=""
    # sh_get_dirtionary_name new_dir
    # echo "new_dir = $new_dir"
    echo "--------------------------------------------------------------------------------"
    echo "Verifying Linux host distribution"
    sh_get_host_type host
    if [ "$host" != "jammy" ]; then
        echo "Unsupported host Linux. Only Ubuntu 22.04 LTS is supported"
    else 
        echo "Ubuntu 22.04 LTS is being used, continuing.."
        echo "--------------------------------------------------------------------------------"
        echo
    fi

    sh_log info "info : test"
    sh_log debug "debug : test"
    sh_log error "error : test"

}



######################################
