#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#
k3_bootswitch_install: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo apt-get install dfu-util

k3_bootswitch_boot_mmc: check_paths_PSDKLA_K3_BOOTSWITCH umount
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode mmc

k3_bootswitch_boot_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode emmc

k3_bootswitch_boot_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_emmc_uda ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode emmc_uda
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_emmc_uda ...  done!!!");

k3_bootswitch_boot_ospi: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode ospi

k3_bootswitch_boot_uart: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk no_no_no

k3_bootswitch_boot_uart_flash_spl_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_spl_emmc

k3_bootswitch_boot_uart_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_spl_xspi

k3_bootswitch_boot_uart_flash_sbl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_sbl_xspi

k3_bootswitch_boot_noboot: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode noboot

k3_bootswitch_boot_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_xspi ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode xspi
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_xspi ... done !!!");




k3_bootswitch_boot_nfs: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP) --sdk no
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs ... done ");

k3_bootswitch_boot_nfs_psdkla: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkla-default 
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_psdkla ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKLA}\/targetNFS"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk psdkla
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_psdkla ... done !!! ");

k3_bootswitch_boot_nfs_psdkra: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkla-default   nfs-setup-tftp-psdkra
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_psdkra ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk psdkra
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_psdkra ...  done !!! ");


k3_bootswitch_boot_nfs_flash_spl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-uboot-img-tftp
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_ospi
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  done !!! ");

k3_bootswitch_boot_nfs_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-uboot-img-tftp
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_xspi
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  done !!! ");

k3_bootswitch_boot_nfs_flash_sbl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkra-sbl-ospi
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  ");
	$(Q)$(ECHO) " >>> build : sbl-bootimage-ospi sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_ospi
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_sbl_ospi ...  done !!! ");


k3_bootswitch_boot_nfs_flash_spl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-uboot-img-tftp
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_boot0
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  done !!! ");

k3_bootswitch_boot_nfs_flash_spl_emmc_boot1: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-uboot-img-tftp
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot1 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_boot1
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot1 ...  done !!! ");

k3_bootswitch_boot_nfs_flash_spl_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-psdkra-spl-default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_uda ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_uda
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_uda ...  done !!! ");

# Tested on j721s2 works. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkra-sbl
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  done !!! ");

# this didn't work on emmc boot0 partiton as the sized is not enough for multiple image. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_opt: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkra-sbl-combined-opt
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0_combined_opt
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  done !!! ");

# this didn't work on emmc boot0 partiton as the sized is not enough for multiple image. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_dev: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkra-sbl-combined-dev
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0_combined_dev
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  done !!! ");
	
	
k3_bootswitch_boot_nfs_flash_sbl_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH  
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup flash_sbl_emmc_uda ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_uda
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup flash_sbl_emmc_uda ...  done !!! ");

k3_bootswitch_boot_dfu_flash_spl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-psdkra-spl-default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_ospi_spl
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_ospi ...  done !!! ");

k3_bootswitch_boot_dfu_flash_sbl_xspi_seperate: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-psdkra-spl-default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_sbl_xspi_seperate
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_ospi ...  done !!! ");


k3_bootswitch_boot_dfu_flash_spl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-psdkra-spl-default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_emmc_boot0 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_emmcboot0_spl
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_emmc_boot0 ...  done !!! ");

k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0_combined_dev: check_paths_PSDKLA_K3_BOOTSWITCH  nfs-setup-tftp-psdkra-sbl-combined-dev
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_sbl_emmc_boot0_combined_dev
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0 ...  done !!! ");

k3_bootswitch_boot_dfu_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs-setup-psdkra-spl-default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_xspi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_xspi_spl
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup k3_bootswitch_boot_dfu_flash_spl_xspi ...  done !!! ");

k3_bootswitch_mount_mmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --mount 1
k3_bootswitch_mount_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --mount 0

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
	# sudo ./dfu-boot.sh --j721e-evm --bootmodDRAM 1
	# sudo ./dfu-boot.sh --j721e-evm --mount 0 //eMMC
	# sudo ./dfu-boot.sh --j721e-evm --mount 1 //SD
	##### sudo ./dfu-boot.sh --j721e-evm --tftp ip
	# sudo ./dfu-boot.sh --j721e-evm --mount 0 //eMMC
	# sudo ./dfu-boot.sh --j721e-evm --mount 1 //SD
	#########################################################
