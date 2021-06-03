#!/bin/bash

# User specifies location of HLOS binaries and the specific OS
##############################################################

# MY_BOARD options are: j721e_evm or j7200_evm
MY_BOARD=$1

# OS options are: linux or qnx
OS=linux

# Linux-specific paths
# --------------------

# First, the directory where the needed Linux binaries are located needs to be defined.
# This directory should already contain the bl31.bin, bl32.bin,
# base-board.dtb (k3-j72*-common-proc-board.dtb), and Image files

# Linux build directory containing all the locally-built Linux-related binaries
LINUX_BUILD_DIR_PATH=/home/fredy/j7/ti-processor-sdk-linux-j7-evm-07_03_00_05/board-support/prebuilt-images

# QNX-specific paths
# ------------------
# First, the directory where the needed QNX binaries are located needs to be defined.
# This directory should already contain the bl31.bin, bl32.bin, and qnx-ifs files
QNX_PREBUILT_DIR_PATH=USER_DEFINED_PATH

# The TOOLCHAIN_PATH_GCC_ARCH64 should be set up as environment variable
# in QNX setup
if [ -z "${TOOLCHAIN_PATH_GCC_ARCH64}" ];
then
    TOOLCHAIN_PATH_GCC_ARCH64=~/qnx700/host/linux/x86_64/usr/bin
fi

##############################################################

# TI packages paths needed for generation of the appimages
SDK_INSTALL_PATH=${PWD}/../../../../../..
PDK_INSTALL_PATH="${SDK_INSTALL_PATH}/pdk_jacinto_07_03_00_29/packages"
SBL_REPO_PATH="${PDK_INSTALL_PATH}/ti/boot/sbl"
MULTICORE_APPIMAGE_GEN_TOOL_PATH="${SBL_REPO_PATH}/tools/multicoreImageGen/bin"
SBL_OUT2RPRC_GEN_TOOL_PATH="${SBL_REPO_PATH}/tools/out2rprc/bin"
MULTICOREAPP_BIN_PATH=${PWD}/../../binary/bin/${MY_BOARD}

LDS_PATH=${PWD}/${OS}

# Defines which appimages this script will create
if [ $OS == "linux" ]; then
    GenFiles=("atf_optee" \
              "tidtb_linux" \
              "tikernelimage_linux"
             );
fi
if [ $OS == "qnx" ]; then
    GenFiles=("atf_optee" \
              "ifs_qnx"
             );
fi

# Preserve original working directory
pushd $PWD > /dev/null

if [ $OS == "linux" ]; then
    cd $LINUX_BUILD_DIR_PATH
    #cd $LINUX_PREBUILT_DIR_PATH
fi
if [ $OS == "qnx" ]; then
    cd $QNX_PREBUILT_DIR_PATH
fi

# Generate all the appimage files (as defined in GenFiles array)
for i in "${GenFiles[@]}"
do
    echo "Generating $i image"
    if [ $OS == "linux" ]; then
		echo "test $LDS_PATH"
        /home/fredy/j7/ti-processor-sdk-rtos-j721e-evm-07_03_00_07/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-ld  -T $LDS_PATH/$i.lds -o $MULTICOREAPP_BIN_PATH/$i.elf
    fi
    if [ $OS == "qnx" ]; then
        ${TOOLCHAIN_PATH_GCC_ARCH64}/aarch64-unknown-nto-qnx7.0.0-ld -T $LDS_PATH/$i.lds -o $MULTICOREAPP_BIN_PATH/$i.elf
    fi
    $SBL_OUT2RPRC_GEN_TOOL_PATH/out2rprc.exe $MULTICOREAPP_BIN_PATH/$i.elf $MULTICOREAPP_BIN_PATH/$i.rprc
    $MULTICORE_APPIMAGE_GEN_TOOL_PATH/MulticoreImageGen LE 55 \
        $MULTICOREAPP_BIN_PATH/$i.appimage 0 $MULTICOREAPP_BIN_PATH/$i.rprc
done

# Restore shell to original working directory
popd > /dev/null
