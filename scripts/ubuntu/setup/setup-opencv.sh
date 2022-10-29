#!/bin/bash
#############################################################################################
# This script is using for sphinx environment setup and using sphinx                        #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-26                                                                      # 
# @update : fredy  V1                                                                        # 
##############################################################################################
VALID_ARGS=( --help -h --install -i --verbose -v --version -s --PATH  -p )

# LOG _LEVEL: debug or no
LOG_LEVEL=no

# Variable : 
APP_INSTALL_PATH=""
REPO_INSTALL_PATH=$SJ_PATH_JACINTO/sdks/
VERSION="4.1.0"
APP_DOWNLOAD_URL="https://github.com/opencv/opencv.git"
APP_DOWNLOAD_URL1="https://github.com/opencv/opencv_contrib.git"
APP_DOWNLOAD_URL2="https://github.com/opencv/opencv/archive/refs/tags/$VERSION.tar.gz"

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

More details , please visit : https://github.com/opencv/opencv
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
			echo "[ $(date) ] --- ${FUNCNAME[0]}: please use -i yes to setup" 
		fi
	fi
}

setup_release_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 1. download the application"
	# setup the package. 
	if [ !  -d $APP_INSTALL_PATH/opencv-$VERSION ];then
		cd $APP_INSTALL_PATH && wget $APP_DOWNLOAD_URL2
		cd $APP_INSTALL_PATH && tar -zxvf $VERSION.tar.gz
	else 
		echo "- Already update. please continuing ---"
	fi
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 2. cmake the application"
	# cd $APP_INSTALL_PATH/opencv-$VERSION && mkdir build 
	# cd $APP_INSTALL_PATH/opencv-$VERSION/build
	# cmake -D CMAKE_BUILD_TYPE=RELEASE \
	# 	-D CMAKE_INSTALL_PREFIX=/usr/local \
	# 	-D INSTALL_C_EXAMPLES=ON \
	# 	-D INSTALL_PYTHON_EXAMPLES=ON \
	# 	-D OPENCV_GENERATE_PKGCONFIG=ON \
	# 	-D OPENCV_EXTRA_MODULES_PATH=$APP_INSTALL_PATH/opencv_contrib/modules \
	# 	-D BUILD_EXAMPLES=ON ..
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 2. build the application"	
	# cd $APP_INSTALL_PATH/opencv-$VERSION/build && make -j1 #-j$(CPU_NUM)


}

setup_src_app()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 0 args --- $#" 
	sudo apt install build-essential cmake git pkg-config libgtk-3-dev \
		libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
		libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
		gfortran openexr libatlas-base-dev python3-dev python3-numpy \
		libtbb2 libtbb-dev libdc1394-22-dev
	# setup repo.
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 1. setup the repo"
	if [ -d $REPO_INSTALL_PATH ];then
		# clone opencv
		cd $REPO_INSTALL_PATH && git clone $APP_DOWNLOAD_URL
		# clone opencv contrib
		cd $REPO_INSTALL_PATH && git clone $APP_DOWNLOAD_URL1
	fi
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 2. update the branch"
	# update branch
	cd $REPO_INSTALL_PATH/opencv && git checkout $VERSION
	cd $REPO_INSTALL_PATH/opencv_contrib  && git checkout $VERSION
	cd $REPO_INSTALL_PATH/opencv_contrib  && git log -1 | grep $VERSION

	#   # build
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 3. build"
	cd $REPO_INSTALL_PATH/opencv && mkdir build
	# TODO Bug fix ： -DWITH_OPENEXR:BOOL="1" --> -DWITH_OPENEXR:BOOL="0"
	cd $REPO_INSTALL_PATH/opencv/cmake 
		# cmake -D CMAKE_BUILD_TYPE=RELEASE \
		# -D CMAKE_INSTALL_PREFIX=/usr/local \
		# -D INSTALL_C_EXAMPLES=ON \
		# -D INSTALL_PYTHON_EXAMPLES=ON \
		# -D OPENCV_GENERATE_PKGCONFIG=ON \
		# -D OPENCV_EXTRA_MODULES_PATH=$REPO_INSTALL_PATH/opencv_contrib/modules \
		# -D BUILD_EXAMPLES=ON ..
		cmake -DBUILD_opencv_highgui:BOOL="1" \
			  -DBUILD_opencv_videoio:BOOL="0" \
			  -DWITH_IPP:BOOL="0" \
			  -DWITH_WEBP:BOOL="1" \
			  -DBUILD_WEBP="1" \
			  -DWITH_OPENEXR:BOOL="0" \
			  -DWITH_IPP_A:BOOL="0" \
			  -DBUILD_WITH_DYNAMIC_IPP:BOOL="0" \
			  -DBUILD_opencv_cudacodec:BOOL="0" \
			  -DBUILD_PNG:BOOL="1"\
			  -DBUILD_opencv_cudaobjdetect:BOOL="0" \
			  -DBUILD_ZLIB:BOOL="1" \
			  -DBUILD_TESTS:BOOL="0" \
			  -DWITH_CUDA:BOOL="0" \
			  -DBUILD_opencv_cudafeatures2d:BOOL="0" \
			  -DBUILD_opencv_cudaoptflow:BOOL="0"\
			  -DBUILD_opencv_cudawarping:BOOL="0" \
			  -DINSTALL_TESTS:BOOL="0" \
			  -DBUILD_TIFF:BOOL="1" \
			  -DBUILD_JPEG:BOOL="1" \
			  -DBUILD_opencv_cudaarithm:BOOL="0" \
			  -DBUILD_PERF_TESTS:BOOL="0" \
			  -DBUILD_opencv_cudalegacy:BOOL="0" \
			  -DBUILD_opencv_cudaimgproc:BOOL="0" \
			  -DBUILD_opencv_cudastereo:BOOL="0" \
			  -DBUILD_opencv_cudafilters:BOOL="0" \
			  -DBUILD_opencv_cudabgsegm:BOOL="0" \
			  -DBUILD_SHARED_LIBS:BOOL="0" \
			  -DWITH_ITT=OFF ../
	# make 
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 4. make"
	cd $REPO_INSTALL_PATH/opencv/cmake && make -j$(CPU_NUM)
	# # make install
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 5. install"
  	# # cd $REPO_INSTALL_PATH/opencv/build && sudo make install
  	# # check the version
	# echo_log "[ $(date) ] --- ${FUNCNAME[0]}: 6. version check"
  	# echo "current version"
  	# pkg-config --modversion opencv
  	# python3 -c "import cv2; print(cv2.__version__)"
}

update_packge_to_target_dictionary()
{
	echo_log "[ $(date) ] --- ${FUNCNAME[0]}: args --- $#" 
	# setup the package. 
	if [ !  -L $APP_INSTALL_PATH/opencv-$VERSION ];then
		ln -s $REPO_INSTALL_PATH/opencv $APP_INSTALL_PATH/opencv-$VERSION
	else 
		echo  "- Already updated the sdk path. please continuing ---"
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
parse_args
# Launch the application:  $1 : number of args
launch $# 
echo "[ $(date) $0] done   !!!"
#---------------------------------------------------------------------------
