#
# Utility script to install all dependant components not included in the
# SDK
#
# - Make sure wget, apt-get, curl proxies are set
#   if required to access these tools from behind corporate firewall.
# - Make sure you have sudo access
# - Tested on Ubuntu 18.04
#
# IMPORANT NOTE:
#   TI provides this as is and may not work as expected on all systems,
#   Please review the contents of this script and modify as needed
#   for your environment
#
#

PSDKLA_ROOTFS=tisdk-default-image-j7-evm.tar.xz
PSDKLA_BOOTFS=boot-j7-evm.tar.gz
ATF_TAG=ti2020.00
OPTEE_TAG=ti2020.00

skip_sudo=0
skip_linux=0

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --skip_sudo)
    skip_sudo=1
    shift # past argument
    ;;
    --qnx_sbl)
    skip_linux=1
    shift # past argument
    ;;
    -h|--help)
    echo Usage: $0 [options]
    echo
    echo Options,
    echo --skip_sudo     use this option to skip steps that need sudo command
    echo --qnx_sbl       use this option for setting up SDK for QNX SBL only, skipping SPL u-boot setup steps
    exit 0
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Track which packages didn't install then print out at the end
declare -a err_packages

if [ $skip_sudo -eq 0 ]
then
    echo "[dof] Creating/Updating system link to libDOF.so ..."
    sudo ln -sf $PWD/j7_c_models/lib/PC/x86_64/LINUX/release/libDOF.so /usr/lib/x86_64-linux-gnu/libDOF.so
    sudo ln -sf $PWD/j7_c_models/lib/PC/x86_64/LINUX/release/libglbce.so /usr/lib/x86_64-linux-gnu/libApicalSIM.so.1

    sudo apt-get update
    declare -a arr=("gcc-5" "g++-5" "libpng-dev" "zlib1g-dev" "libtiff-dev" "libsdl2-dev" "libsdl2-image-dev" \
        "graphviz" "graphviz-dev" "build-essential" "libxmu-dev" "libxi-dev" "libgl-dev" "libosmesa-dev" "python3" "python3-pip" "curl"    \
        "libz1:i386" "libc6-dev-i386" "libc6:i386" "libstdc++6:i386" "g++-multilib" "git" "diffstat" "texinfo"\
        "gawk" "chrpath" "libfreetype6-dev" "mono-runtime" "flex" "libssl-dev" "u-boot-tools" "libdevil-dev"  \
        "bison" "python3-pyelftools" "python3-dev" "libx11-dev")

    if ! sudo apt-get install -y "${arr[@]}"; then
        for i in "${arr[@]}"
        do
            if ! sudo apt-get install -y "$i"; then
               err_packages+=("$i")
            fi
        done
    fi
else
    echo ""
    echo "Skipping apt-get install, ensure all required packages are installed on the machine by sudo user"
    echo ""
fi

if [ $skip_linux -eq 0 ]
then
    echo "[psdkla ${PSDKLA_ROOTFS}] Checking ..."
    if [ ! -d targetfs ]
    then
        if [ -f ${PSDKLA_ROOTFS} ]
        then
            echo "[psdkla ${PSDKLA_ROOTFS}] Installing files ..."
            mkdir targetfs
            tar xf ${PSDKLA_ROOTFS} -C targetfs/
        else
            echo
            echo "ERROR: Missing $PWD/${PSDKLA_ROOTFS}.  Download and try again"
            exit -1
        fi
    fi
    echo "[psdkla ${PSDKLA_ROOTFS}] Done "

    echo "[psdkla ${PSDKLA_BOOTFS}] Checking ... "
    if [ ! -d bootfs ]
    then
        if [ -f ${PSDKLA_BOOTFS} ]
        then
            echo "[psdkla ${PSDKLA_BOOTFS}] Installing files ..."
            mkdir bootfs
            tar xf ${PSDKLA_BOOTFS} -C bootfs/
        else
            echo
            echo "ERROR: Missing $PWD/${PSDKLA_BOOTFS}.  Download and try again"
            exit -1
        fi
    fi
    echo "[psdkla ${PSDKLA_BOOTFS}] Done "
fi

echo "[gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf] Checking ..."
if [ ! -d gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf ]
then
    wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz --no-check-certificate
    tar xvf gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz > /dev/null
    rm gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz
fi
echo "[gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf] Done"

echo "[gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu] Checking ..."
if [ ! -d gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu ]
then
    wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz --no-check-certificate
    tar xf gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz > /dev/null
    rm gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
fi
echo "[gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu] Done"

echo "[gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf] Checking ..."
if [ ! -d gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf ]
then
    wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz --no-check-certificate
    tar xf gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz > /dev/null
    rm gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz
fi
echo "[gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf] Done"

# ATF check
echo "[ATF] Checking ..."
if [ ! -d ./arm-trusted-firmware ]
then
    git clone git://git.ti.com/atf/arm-trusted-firmware.git
    cd arm-trusted-firmware
    git checkout -b dev $ATF_TAG
    cd ..
fi
echo "[ATF] Checking ... Done"

# OPTEE check
echo "[OPTEE] Checking ..."
if [ ! -d ./ti-optee-os ]
then
    git clone git://git.ti.com/optee/ti-optee-os.git
    cd ti-optee-os
    git checkout -b dev $OPTEE_TAG
    cd ..
fi
echo "[OPTEE] Checking ... Done"

echo "[opkg-utils] Checking ..."
if [ ! -d opkg-utils-master ]
then
    wget https://git.yoctoproject.org/cgit/cgit.cgi/opkg-utils/snapshot/opkg-utils-master.tar.gz --no-check-certificate
    tar -xf opkg-utils-master.tar.gz
    rm opkg-utils-master.tar.gz
fi
echo "[opkg-utils] Done"

echo "[glm] Checking ..."
if [ ! -d glm ]
then
    wget https://github.com/g-truc/glm/releases/download/0.9.8.0/glm-0.9.8.0.zip --no-check-certificate
    unzip glm-0.9.8.0.zip > /dev/null
    rm glm-0.9.8.0.zip
fi
echo "[glm] Done"

echo "[glew] Checking ..."
if [ ! -d glew-2.0.0 ]
then
    wget https://sourceforge.net/projects/glew/files/glew/2.0.0/glew-2.0.0.zip/download --no-check-certificate
    mv download glew-2.0.0.zip
    unzip glew-2.0.0.zip > /dev/null
    rm glew-2.0.0.zip
    cd glew-2.0.0
    make > /dev/null
    if [ $skip_sudo -eq 0 ]
    then
        sudo make install
    else
        echo "Skipping make install -> requires sudo permission"
    fi
    make clean > /dev/null
    cd -
fi
echo "[glew] Done"

echo "[pip] Checking ..."
if [ ! -f ~/.local/bin/pip ]
then
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    python3 get-pip.py --user
    rm get-pip.py
fi

if [ $skip_sudo -eq 0 ]
then
    sudo -H python3 -m pip install --upgrade pip
fi
echo "[pip] Checking ... Done"

echo "[pip] Installing dependant python packages ..."
# There are needed to build ATF, OPTEE
if ! command -v pip3 &> /dev/null
then
	export PATH=${HOME}/.local/bin:$PATH
fi
pip3 install pycrypto pycryptodomex --user
echo "[pip] Installing dependant python packages ... Done"

# check if there is a err_packages
if [ -z "$err_packages" ]; then
    echo "Packages installed successfully"
else
    echo "ERROR: The following packages were not installed:"
    for i in "${err_packages[@]}"
    do
       echo "$i"
    done
fi
