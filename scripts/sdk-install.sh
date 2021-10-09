#!/bin/sh

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Process command line...
while [ $# -gt 0 ]; do
  case $1 in
    --install_dir)
      shift;
      install_dir=$1;
      ;;
     *)
      shift;
      ;;
  esac
done

if [ "x$install_dir" = "x" ]; then
    # Verify that the script is being called within untar SDK directory
    if [ ! -d "$PWD/board-support" -a ! -f "$PWD/Rules.make" ]; then
        echo "Script must be called within untarred sdk directory"
        exit 1
    else
        install_dir="$PWD"
    fi
fi

# Get full path to SDK directory
cd "$install_dir"
install_dir="$PWD"
cd -

if [ ! -d $install_dir ]; then
	echo "Installation directory does not exist"
	exit 1
fi

# Remove any .svn directories that were packaged by the sourceipks
rm -rf `find $install_dir -name ".svn"`


# Update Rules.make variables
sed -i -e s=__SDK__INSTALL_DIR__=$install_dir= $install_dir/Rules.make 

# Find the linux directory name
linux=`find $install_dir/board-support -maxdepth 1 -name "linux*"`
linux=`basename $linux`
sed -i -e s=__KERNEL_NAME__=$linux= $install_dir/Rules.make

threads=`cat /proc/cpuinfo | grep -c processor`

# Create a newline
echo >> $install_dir/Rules.make
# Set optimal value for the make file's -j option
echo "MAKE_JOBS=$threads" >> $install_dir/Rules.make

cd -


# Install toolchain sdk
$install_dir/linux-devkit.sh -y -d $install_dir/linux-devkit

# Remove toolchain sdk
rm $install_dir/linux-devkit.sh


# Update example applications CCS project files

# Grab some essential variables from environment-setup
REAL_MULTIMACH_TARGET_SYS=`sed -n 's/^export REAL_MULTIMACH_TARGET_SYS=//p' $install_dir/linux-devkit/environment-setup`
TOOLCHAIN_SYS=`sed -n 's/^export TOOLCHAIN_SYS=//p' $install_dir/linux-devkit/environment-setup`
SDK_SYS=`sed -n 's/^export SDK_SYS=//p' $install_dir/linux-devkit/environment-setup`

# Grab toolchain's GCC version
GCC_VERSION=`ls $install_dir/linux-devkit/sysroots/$SDK_SYS/usr/lib/gcc/$TOOLCHAIN_SYS/`

TOOLCHAIN_TARGET_INCLUDE_DIR="linux-devkit/sysroots/$REAL_MULTIMACH_TARGET_SYS/usr/include"
TOOLCHAIN_INCLUDE_DIR="linux-devkit/sysroots/$SDK_SYS/usr/lib/gcc/$TOOLCHAIN_SYS/$GCC_VERSION/include"

SDK_PATH_TARGET="linux-devkit/sysroots/$REAL_MULTIMACH_TARGET_SYS/"

sed -i -e s=__SDK_PATH_TARGET__=$SDK_PATH_TARGET= $install_dir/Rules.make

if [ -f "$install_dir/bin/unshallow-repositories.sh" ]
then
    sed -i -e s=__SDK_INSTALL_DIR__=$install_dir= $install_dir/bin/unshallow-repositories.sh
fi

if [ -f "$install_dir/bin/create-ubifs.sh" ]
then
    sed -i -e s=__SDK_INSTALL_DIR__=$install_dir= $install_dir/bin/create-ubifs.sh
fi

# Modify create-sdcard.sh to have user-supplied installation directory
if [ -f "${install_dir}/bin/create-sdcard.sh" ]
then
    sed -i -e "s|ti-sdk.*\[0-9\]|${install_dir##*/}|g" ${install_dir}/bin/create-sdcard.sh
fi

# Update CCS project files using important paths to headers

find $install_dir/example-applications -type f -exec sed -i "s|<TOOLCHAIN_TARGET_INCLUDE_DIR>|$TOOLCHAIN_TARGET_INCLUDE_DIR|g" {} \;
find $install_dir/example-applications -type f -exec sed -i "s|<TOOLCHAIN_INCLUDE_DIR>|$TOOLCHAIN_INCLUDE_DIR|g" {} \;


if [ -f "$install_dir/sdk-install.sh" ]; then
	# File is only able to run once so delete it from the SDK
	rm "$install_dir/sdk-install.sh"
fi

echo "Installation completed!"
exit 0

