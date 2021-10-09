#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#

k3_bootswitch_install: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo apt-get install dfu-util

k3_bootswitch_boot_mmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --bootmode mmc

k3_bootswitch_boot_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --bootmode emmc

k3_bootswitch_boot_ospi: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --bootmode ospi
k3_bootswitch_boot_uart: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --bootmode uart
k3_bootswitch_boot_noboot: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --bootmode noboot

k3_bootswitch_mount_mmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --mount 1
k3_bootswitch_mount_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --j721e-evm --mount 0

k3_bootswitch_help: check_paths_PSDKLA_K3_BOOTSWITCH
	##### k3 bootswitch tools introduction
	# 1. USB connect to Linux PC
	# 2. main_uart connect to Linux PC
	# 3. * j721e-evm settings  => SW8 = 1000 0000      SW9 = 0010 0000      SW3 = 0101 00 1010
	# 4. USB replay setup:  cp k3bootswitch.conf ~/HOME/.config/
	#      (usbrelay HURTM_1=0 HURTM_2=0 && sleep 0.5 && usbrelay HURTM_1=1 HURTM_2=1 && sleep 0.1) >/dev/null 2>&1
	##### install 
	# sudo apt-get install dfu-util
	##### boot in differenct mode 
	# sudo ./dfu-boot.sh --j721e-evm --bootmode mmc
	# sudo ./dfu-boot.sh --j721e-evm --bootmode emmc
	# sudo ./dfu-boot.sh --j721e-evm --bootmode ospi
	# sudo ./dfu-boot.sh --j721e-evm --bootmode uart
	# sudo ./dfu-boot.sh --j721e-evm --bootmode noboot
	##### mount the sd/emmc
	# sudo ./dfu-boot.sh --j721e-evm --mount 0 //eMMC
	# sudo ./dfu-boot.sh --j721e-evm --mount 1 //SD
	#########################################################
