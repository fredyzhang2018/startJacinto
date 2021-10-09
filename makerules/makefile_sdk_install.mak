#
# Utility makefile to build codec libraries
#
# Edit this file to suit your specific build needs
#

# Vision-SDK environment install 
install_dependencies:
	cd $(SJ_PATH_PSDKRA); $(SJ_PATH_PSDKRA)/psdk_rtos_auto/scripts/setup_psdk_rtos_auto.sh

install_ccs_scripts:
	@echo "Please run below in scripts";
	@echo "load(\"/home/fredy/j7/psdk_rtos_auto_j7_06_00_01_00/pdk/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"

install_targetfs:
	cp ${SJ_PATH_PSDKLA}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${SJ_PATH_PSDKRA}/
	cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-rootfs-image-j7-evm.tar.xz ${SJ_PATH_PSDKRA}/



