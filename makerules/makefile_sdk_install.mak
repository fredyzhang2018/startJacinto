#
# Utility makefile to build codec libraries
#
# Edit this file to suit your specific build needs
#

# Vision-SDK environment install 
install_dependencies:
	cd $(PSDKRA_PATH); $(PSDKRA_PATH)/psdk_rtos_auto/scripts/setup_psdk_rtos_auto.sh

install_ccs_scripts:
	@echo "Please run below in scripts";
	@echo "load(\"/home/fredy/j7/psdk_rtos_auto_j7_06_00_01_00/pdk/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"

install_targetfs:
	cp ${PSDKLA_PATH}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${PSDKRA_PATH}/
	cp ${PSDKLA_PATH}/filesystem/tisdk-rootfs-image-j7-evm.tar.xz ${PSDKRA_PATH}/



