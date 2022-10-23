echo "-----------------update sd PSDKLA ------------------"
echo $0 $1 $2
BOOT=$1
ROOTFS=$2
echo "Work path: $PWD BOOT=$BOOT ROOTFS=$ROOTFS"
test -e ${ROOTFS} && rootfs=y || rootfs=n;
test -e ${BOOT} && boot=y || boot = n;
echo "rootfs: $rootfs"
echo "boot: $boot"
if [ "$rootfs" == "y" ]||[ "$boot" == "y" ];then

	echo "Start the process"
	sudo fdisk -l | grep /dev/sd
	
	read -p ">>>>>Please input the SD Device:" SD_DEVICE
	echo "SD_DEVICE: $SD_DEVICE"
	read -p ">>>>>Please sure to y:" yyy
	if [ "$yyy" == "y" ];then
		echo "sudo ${SJ_PATH_PSDKLA}/bin/mksdboot.sh --device ${SD_DEVICE} --sdk ${SJ_PATH_PSDKLA}"
		sudo ${SJ_PATH_PSDKLA}/bin/mksdboot.sh --device ${SD_DEVICE} --sdk ${SJ_PATH_PSDKLA}
		sync
	fi
else
echo ">>>>>>>>>>>please insert sd card!!!"
fi
echo "------------end"
