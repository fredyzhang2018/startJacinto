#!/bin/sh

echo $0 $1 $2 $#
OPENCV_PATH=$1
OPENCV_VERSION=$2
OPENCV_NUM_INPUT=$#
echo $OPENCV_PATH $OPENCV_VERSION $OPENCV_NUM_INPUT
# This script will install the opencv
usage ()
{
  echo "***************************************************************"
  echo "Usage: $0  PATH and Version  "
  echo "E.g: $0 PATH VERSION"
  echo $SJ_NUM_INPU
  echo "***************************************************************"
}

check_parameter ()
{
  echo "----------------------------------------------------------------------"
	if [ $OPENCV_NUM_INPUT -ne 2 ]; then
	  echo "Need two parameter"
	  usage
	  exit 1;
	fi

    if [ ! -d $OPENCV_PATH ]; then
        echo "please help to check your $OPENCV_PATH "
    fi
}

install_opencv ()
{
  sudo apt install build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev
  # downlaod the repo
  cd $OPENCV_PATH && git clone https://github.com/opencv/opencv.git
  cd $OPENCV_PATH && git clone https://github.com/opencv/opencv_contrib.git
  # check the version
  cd $OPENCV_PATH/opencv && git checkout $OPENCV_VERSION
  cd $OPENCV_PATH/opencv_contrib && git checkout $OPENCV_VERSION
  # build
  cd $OPENCV_PATH/opencv && mkdir build
  cd $OPENCV_PATH/opencv/build
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=$OPENCV_PATH/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
  # make 
  make -j$(CPU_NUM)
  # install 
  sudo make install
  # check the version
  echo "current version"
  pkg-config --modversion opencv
  python3 -c "import cv2; print(cv2.__version__)"
}

# check the parameter 
check_parameter
# install opencv
install_opencv
