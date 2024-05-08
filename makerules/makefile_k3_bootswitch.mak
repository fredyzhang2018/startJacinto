#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#
k3_bootswitch_install: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_install ...  ");
	$(Q)cd $(SJ_PATH_K3_BOOTSWITCH) && sudo apt-get install dfu-util
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_install ...  done!");

k3_bootswitch_boot_mmc: check_paths_PSDKLA_K3_BOOTSWITCH umount
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_mmc ...  ");
	$(Q)cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode mmc
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_mmc ... done!");

k3_bootswitch_boot_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_emmc ...  ");
	$(Q)cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode emmc
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_emmc ... done!");

k3_bootswitch_boot_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_emmc_uda ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode emmc_uda
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_emmc_uda ...  done!!!");

k3_bootswitch_boot_ospi: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_ospi ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode ospi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_ospi ...  done!!!");
	

k3_bootswitch_boot_uart: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk no_no_no
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart ...  done!!!");

k3_bootswitch_boot_uart_flash_spl_emmc: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_spl_emmc ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_spl_emmc
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_spl_emmc ...  done!!!");

k3_bootswitch_boot_uart_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_spl_xspi ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_spl_xspi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_spl_xspi ...  done!!!");

k3_bootswitch_boot_uart_flash_sbl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_sbl_xspi ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode uart --sdk flash_sbl_xspi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_uart_flash_sbl_xspi ...  done!!!");

k3_bootswitch_boot_noboot: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_noboot ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode noboot
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_noboot ...  done!!!");

k3_bootswitch_boot_xspi: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_xspi ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --bootmode xspi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_xspi ...  done!!!");




k3_bootswitch_boot_nfs: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP) --sdk no
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs ...  done!!!");

k3_bootswitch_boot_nfs_psdkla: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkla_default  nfs_setup_tftp_psdkla
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_psdkla ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKLA}\/targetNFS"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk psdkla
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_psdkla ...  done!!!");

k3_bootswitch_boot_nfs_psdkra: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkla_default   nfs_setup_tftp_psdkra
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_psdkra ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk psdkra
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_psdkra ...  done!!!");


k3_bootswitch_boot_nfs_flash_spl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_uboot_img_tftp
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_ospi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_ospi ...  done!!!");

k3_bootswitch_boot_nfs_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_uboot_img_tftp
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_xspi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_xspi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_xspi ...  done!!!");

k3_bootswitch_boot_nfs_flash_sbl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkra_sbl_ospi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_ospi ...  ");
	$(Q)$(ECHO) " >>> build : sbl-bootimage-ospi sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_ospi
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_ospi ...  done!!!");


k3_bootswitch_boot_nfs_flash_spl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_uboot_img_tftp
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_boot0
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_boot0 ...  done!!!");

k3_bootswitch_boot_nfs_flash_spl_emmc_boot1: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_uboot_img_tftp
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_boot1 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_boot1
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_boot1 ...  done!!!");

k3_bootswitch_boot_nfs_flash_spl_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_psdkra_spl_default
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_uda ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_spl_emmc_uda
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_spl_emmc_uda ...  done!!!");

# Tested on j721s2 works. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkra_sbl
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0 ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0 ...  done!!!");

# this didn't work on emmc boot0 partiton as the sized is not enough for multiple image. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_opt: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkra_sbl_combined_opt
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_opt ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0_combined_opt
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_opt ...  done!!!");

# this didn't work on emmc boot0 partiton as the sized is not enough for multiple image. 
k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_dev: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkra_sbl_combined_dev
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_dev ...  ");
	$(Q)$(ECHO) " >>> separate : sbl-bootimage-emmc-boot0 sbl-vision_apps-bootimage sbl-linux-bootimage "
	$(Q)$(ECHO) " >>> combined : sbl-combined-bootimage-emmc-boot0"
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_boot0_combined_dev
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_dev ...  done!!!");
	
	
k3_bootswitch_boot_nfs_flash_sbl_emmc_uda: check_paths_PSDKLA_K3_BOOTSWITCH  
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_uda ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk flash_sbl_emmc_uda
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_nfs_flash_sbl_emmc_uda ...  done!!!");

k3_bootswitch_boot_dfu_flash_spl_ospi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_psdkra_spl_default
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_ospi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_ospi_spl
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_ospi ...  done!!!");

k3_bootswitch_boot_dfu_flash_sbl_xspi_seperate: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_psdkra_spl_default
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_sbl_xspi_seperate ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_sbl_xspi_seperate
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_sbl_xspi_seperate ...  done!!!");


k3_bootswitch_boot_dfu_flash_spl_emmc_boot0: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_psdkra_spl_default
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_emmc_boot0 ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_emmcboot0_spl
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_emmc_boot0 ...  done!!!");

k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0_combined_dev: check_paths_PSDKLA_K3_BOOTSWITCH  nfs_setup_tftp_psdkra_sbl_combined_dev
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0_combined_dev ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_sbl_emmc_boot0_combined_dev
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0_combined_dev ...  done!!!");

k3_bootswitch_boot_dfu_flash_spl_xspi: check_paths_PSDKLA_K3_BOOTSWITCH    nfs_setup_psdkra_spl_default
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_xspi ...  ");
	$(Q)sed -i  "/nfspath =/c nfspath = ${SJ_PATH_PSDKRA}\/targetfs"  $(HOME)/.config/k3bootswitch.conf
	$(Q)sed -i  "s/^nfs/	nfs/g" $(HOME)/.config/k3bootswitch.conf
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --tftp $(SJ_SERVER_IP)  --sdk dfu_flash_xspi_spl
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_boot_dfu_flash_spl_xspi ...  done!!!");

k3_bootswitch_mount_mmc: check_paths_PSDKLA_K3_BOOTSWITCH nfs_setup_uboot_img_prebuild
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_mount_mmc ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --mount 1
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_mount_mmc ...  done!!!");

k3_bootswitch_mount_emmc: check_paths_PSDKLA_K3_BOOTSWITCH nfs_setup_uboot_img_prebuild
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_mount_emmc ...  ");
	cd $(SJ_PATH_K3_BOOTSWITCH) && sudo ./dfu-boot.sh --$(SJ_SOC_TYPE)-evm --mount 0
	$(Q)$(call sj_echo_log, info , "1. k3_bootswitch_mount_emmc ...  done!!!");

k3_bootswitch_help: check_paths_PSDKLA_K3_BOOTSWITCH
	$(Q)$(call sj_echo_log, info , "# k3_bootswitch_help....."); 
	$(Q)$(call sj_echo_log, info , "##### k3 bootswitch tools introduction"); 
	$(Q)$(call sj_echo_log, info , "# 1. USB connect to Linux PC"); 
	$(Q)$(call sj_echo_log, info , "# 2. main_uart connect to Linux PC"); 
	$(Q)$(call sj_echo_log, info , "# 3. j721e-evm settings: SW8 = 1000 0000 SW9 = 0010 0000 SW3 = 0101 00 1010"); 
	$(Q)$(call sj_echo_log, critical , "# 4. USB replay setup:  cp k3bootswitch.conf ~/.config/k3bootswitch.conf"); 
	$(Q)$(call sj_echo_log, info , "##### install"); 
	$(Q)$(call sj_echo_log, info , "# sudo apt-get install dfu-util"); 
	$(Q)$(call sj_echo_log, info , "##### boot in differenct mode"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --bootmode mmc"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --bootmode emmc"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --bootmodDRAM 1"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --mount 0 //eMMC"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --mount 1 //SD"); 
	$(Q)$(call sj_echo_log, info , "# sudo ./dfu-boot.sh --j721e-evm --tftp ip"); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_dfu_flash_sbl_emmc_boot0_combined_dev", "flashing SBL emmc boot0 combined..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_dfu_flash_sbl_xspi_seperate", "flashing SBL xspi seperate..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_dfu_flash_spl_emmc_boot0", "flashing SPL emmc boot0 ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_dfu_flash_spl_ospi", "flashing SPL ospi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_dfu_flash_spl_xspi", "flashing SPL xspi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_emmc", "boot from emmc ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_emmc_uda", "boot from emmc uda ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_mmc", "boot from mmc ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs", "boot from nfs ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_psdkla", "boot from nfs psdkla ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_psdkra", "boot from nfs psdkra ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_noboot", "boot from noboot ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_ospi", "boot from ospi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_uart", "boot from uart ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_xspi", "boot from xspi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_uart_flash_sbl_xspi", "flash sbl xspi from uart..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_uart_flash_spl_emmc", "flash spl emmc from uart..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_uart_flash_spl_xspi", "flash spl xspi from uart..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0", "nfs flash sbl emmc boot0..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_dev", "nfs flash sbl emmc boot0 combined dev ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_sbl_emmc_boot0_combined_opt", "nfs flash sbl emmc boot0 combined opt ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_sbl_emmc_uda", "nfs flash sbl emmc uda ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_sbl_ospi", "nfs flash sbl ospi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_emmc_boot0", "nfs flash spl emmc boot0 ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_emmc_boot1", "nfs flash spl emmc boot1 ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_emmc_uda", "nfs flash spl emmc uda  ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_ospi", "nfs flash spl ospi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_xspi", "nfs flash spl xspi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_boot_nfs_flash_spl_xspi", "nfs flash spl xspi ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_install", "install dfu tools ... "); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_mount_emmc", "mount emmc ..."); 
	$(Q)$(call sj_echo_log, help , "k3_bootswitch_mount_mmc", "mount mmc ..."); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "# k3_bootswitch_help..... done"); 
