##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################
# Soc J721e J7200
SJ_MCUSW_SOC = j721e
# EVM Board: j721e_evm
SJ_MCUSW_BOARD = j721e_evm
# mpu1_0, mcu1_0, mcu1_1, mcu2_0, mcu2_1, mcu3_0, mcu3_1, c66xdsp_1, c66xdsp_2, c7
SJ_MCUSW_CORE = mcu1_0
# Modules: can_boot_app_mcu_rtos can_profile_app
#		CDD IPC :  cdd_ipc_app (mcu2_1 ) cdd_ipc_app_rc_linux  (mcu2_1) cdd_ipc_profile_app_rc_linux (mcu1_0))
#       	cdd_ipc_profile_app_rc_linux tirtos  mcu1_0 (SDK8.0) Verified. 
#			cdd_ipc_profile_app_rc_linux tirtos
SJ_MCUSW_MODULES =can_boot_app_mcu_rtos
# debug or release
SJ_MCUSW_BUILD_PROFILE=release
# OS TYPE :  baremetal fro MCAL examples  freertos (tirtos remove from 8.0 SDK.)
SJ_MCUSW_BUILD_OS_TYPE =freertos


mcusw-build: check_paths_PSDKRA mcusw-build-configure
ifeq ($(SJ_MCUSW_BUILD_OS_TYPE),tirtos)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build $(SJ_MCUSW_MODULES) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
			BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) -s BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE) -j$(CPU_NUM)
else
	$(MAKE) -C $(SJ_PATH_MCUSS)/build $(SJ_MCUSW_MODULES) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
		 -s BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE) -j$(CPU_NUM)
endif 

mcusw-build-configure: check_paths_PSDKRA
	$(Q)$(call sj_echo_log, 0 , "Modules : $(SJ_MCUSW_MODULES) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
			BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) ");

mcusw-build-clean: check_paths_PSDKRA mcusw-build-configure
ifeq ($(SJ_MCUSW_BUILD_OS_TYPE),tirtos)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build $(SJ_MCUSW_MODULES)_clean SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
			BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) -s BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE) -j$(CPU_NUM)
else
	$(MAKE) -C $(SJ_PATH_MCUSS)/build $(SJ_MCUSW_MODULES)_clean SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
			-s BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE) -j$(CPU_NUM)
endif 

## CAN BOOT APP MCU RTOS ##########################################################
# BISTFUNC=disabled, BOOTFUNC=enabled, HLOSBOOT=none, BOOTMODE=mmcsd
SJ_BOOTMODE = mmcsd
# Linux or QNX or none for linux
SJ_HLOSBOOT = linux
SJ_MCUSS_CAN_FUNCTION= disabled
mcusw-build-can-boot-app-mcu: pdk-sbl-mmcsd-img
	$(Q)$(call sj_echo_log, 0 , " cuss-build-can-boot-app-mcu : start build the can_boot_app_mcu_rtos!!!");
ifeq ($(SJ_BOOTMODE),mmcsd)
ifeq ($(SJ_HLOSBOOT),linux)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_boot_app_mcu_rtos HLOSBOOT=$(SJ_HLOSBOOT) BOOTMODE=$(SJ_BOOTMODE) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
		BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) CANFUNC=$(SJ_MCUSS_CAN_FUNCTION) BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE)  -s -j$(CPU_NUM) 
else 
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_boot_app_mcu_rtos BOOTMODE=$(SJ_BOOTMODE) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
		BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE)  -s -j$(CPU_NUM) 		
endif 
else
	$(Q)$(call sj_echo_log, 2 , " not supported, please check !!!");
endif
	$(Q)$(call sj_echo_log, 0 , " --- $(SJ_PATH_PSDKRA)/mcusw/binary/can_boot_app_mcu_rtos/bin/j721e_evm !!!");

mcusw-build-can-boot-app-mcu-clean:
ifeq ($(SJ_BOOTMODE),mmcsd)
ifeq ($(SJ_HLOSBOOT),linux)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_boot_app_mcu_rtos_clean HLOSBOOT=$(SJ_HLOSBOOT) BOOTMODE=$(SJ_BOOTMODE) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
		BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE)  CANFUNC=$(SJ_MCUSS_CAN_FUNCTION) BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE)  -s -j$(CPU_NUM) 
else 
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_boot_app_mcu_rtos_clean BOOTMODE=$(SJ_BOOTMODE) SOC=$(SJ_MCUSW_SOC) BOARD=$(SJ_MCUSW_BOARD) CORE=$(SJ_MCUSW_CORE) \
		BUILD_OS_TYPE=$(SJ_MCUSW_BUILD_OS_TYPE) BUILD_PROFILE=$(SJ_MCUSW_BUILD_PROFILE)  -s -j$(CPU_NUM) 		
endif 
else
	$(Q)$(call sj_echo_log, 2 , " not supported, please check !!!");
endif
	$(Q)$(call sj_echo_log, 0 , " --- $(SJ_PATH_PSDKRA)/mcusw/binary/can_boot_app_mcu_rtos/bin/j721e_evm !!!");

# ## Can Profiling Application
mcusw-sbl-mmcsd-img:
	$(Q)echo "start build sbl for mmcsd ";
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release pdk_libs      -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release sbl_mmcsd_img -s -j$(CPU_NUM)
	cd $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/ && ./makemulticore.sh j721e_evm
	$(Q)echo "test !!!";
# please run :  mcuss-sbl-mmcsd-img mcusw-build-can-boot-app-mcu before run below command. 
mcusw-sd-install-sbl-mmcsd-imgs: check_paths_sd_boot # mcuss-sbl-mmcsd-img mcusw-build-can-boot-app-mcu
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage             $(SJ_BOOT)/tiboot3.bin
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin                                                        $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/binary/can_boot_app_mcu_rtos/bin/j721e_evm/can_boot_app_mcu_rtos_mcu1_0_release.appimage       $(SJ_BOOT)/app
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MCU2_0_MCU2_1_stage1.appimage         $(SJ_BOOT)/lateapp1
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_DSPs_MCU3_0_MCU3_1_stage2.appimage    $(SJ_BOOT)/lateapp2
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MPU1_0_stage3.appimage                $(SJ_BOOT)/lateapp3
	echo "install done"
	echo "run on evm ------> "
	echo "      1. MCU UART port, channel  #2 (i.e. second UART instance) - MCU R5F CAN Boot Application logs "
	echo "      2. Main UART port, channel #1 (i.e. third UART instance) - Linux/QNX boot logs (only if Linux/QNX build enabled)"
	echo "      3. Main UART port, channel #2 (i.e. fourth UART instance) - Main Domain RTOS application logs "

DTB_FILE?=$(SJ_PATH_PSDKLA)/board-support/`ls $(SJ_PATH_PSDKLA)/board-support/ | grep linux-`/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board
SBL_BUILD_DTB?=yes
mcusw-sbl-mmcsd-img-hlos:
	$(Q)$(call sj_echo_log, 0 , " --- 1. start build sbl for mmcsd !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 2. set the bootargs:");
ifeq ($(SBL_BUILD_DTB),yes)
	$(Q)sed -i '/^		bootargs =/c		bootargs = "console=ttyS2,115200n8 earlycon=ns16550a,mmio32,0x02800000 root=/dev/mmcblk1p2 rw rootfstype=ext4 rootwait";' $(DTB_FILE).dts
	$(Q)sed -i '/^bootargs =/c		bootargs = "console=ttyS2,115200n8 earlycon=ns16550a,mmio32,0x02800000 root=/dev/mmcblk1p2 rw rootfstype=ext4 rootwait";' $(DTB_FILE).dts
endif
	$(Q)$(call sj_echo_log, 0 , " --- 3. build the dtb and update the base-board.dtb");
ifeq ($(SBL_BUILD_DTB),yes)
	$(Q)make la-linux-dtbs
	$(Q)cp $(DTB_FILE).dtb $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/base-board.dtb
	$(Q)$(call sj_echo_log, 0 , " ---    build dtb : $(DTB_FILE).dtb");
else 
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/bin/j721e_evm/base-board.dtb $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/base-board.dtb
	$(Q)$(call sj_echo_log, 0 , " ---    default dtb :$(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/bin/j721e_evm/base-board.dtb ");
endif
	$(Q)ls -l $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/base-board.dtb
	$(Q)$(call sj_echo_log, 0 , " --- 4. update: $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/constructappimageshlos.sh ");
	$(Q)$(call sj_echo_log, 0 , " --- 5. build PDK and PDK libs");
	$(Q)$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release pdk_libs      -s -j$(CPU_NUM)
	$(Q)$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release sbl_mmcsd_img -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 6. appimage build");
	cd $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/hlos/ && ./constructappimageshlos.sh j721e_evm
	mkdir -p $(SJ_PATH_VISION_SDK_BUILD)/out/sbl_combined_bootfiles
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/atf_optee.appimage  $(SJ_PATH_VISION_SDK_BUILD)/out/sbl_combined_bootfiles                            
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tidtb_linux.appimage $(SJ_PATH_VISION_SDK_BUILD)/out/sbl_combined_bootfiles
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tikernelimage_linux.appimage $(SJ_PATH_VISION_SDK_BUILD)/out/sbl_combined_bootfiles
	$(Q)ls -l $(SJ_PATH_VISION_SDK_BUILD)/out/sbl_combined_bootfiles
	$(Q)$(call sj_echo_log, 0 , " --- 7. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");

# Build Dependcy: mcusw-build-can-boot-app-mcu
mcusw-sbl-mmcsd-img-hlos-install-sd: mcusw-sbl-mmcsd-img-hlos mcusw-build-can-boot-app-mcu check_paths_sd_boot  
	$(Q)$(call sj_echo_log, 0 , " --- 1. update images "); 
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage             $(SJ_BOOT)/tiboot3.bin
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin                                                        $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/binary/can_boot_app_mcu_rtos/bin/j721e_evm/can_boot_app_mcu_rtos_mcu1_0_release.appimage       $(SJ_BOOT)/app
	#$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MCU2_0_MCU2_1_stage1.appimage         $(SJ_BOOT)/lateapp1
	#$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_DSPs_MCU3_0_MCU3_1_stage2.appimage    $(SJ_BOOT)/lateapp2
	#$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MPU1_0_stage3.appimage                $(SJ_BOOT)/lateapp3
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/atf_optee.appimage                              $(SJ_BOOT)/
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tidtb_linux.appimage                            $(SJ_BOOT)/
	$(Q)cp -v $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tikernelimage_linux.appimage                    $(SJ_BOOT)/	
	$(Q)$(call sj_echo_log, 0 , " --- 1. update images --- done !!! "); 
	sync
	$(Q)echo "install done"
	$(Q)echo "run on evm ------> "
	$(Q)echo "      1. MCU UART port, channel #2 (i.e. second UART instance) - MCU R5F CAN Boot Application logs "
	$(Q)echo "      2. Main UART port, channel #1 (i.e. third UART instance) - Linux/QNX boot logs (only if Linux/QNX build enabled)"
	$(Q)echo "      3. Main UART port, channel #2 (i.e. fourth UART instance) - Main Domain RTOS application logs "
	$(Q)$(call sj_echo_log, 0 , " --- 7. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");

### CDD IPC ccs setup demo
mcusw-cdd-ipc-demo-ccs-setup:
	$(Q)echo "start ccs demo setup check";
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app/bin/j721e_evm/cdd_ipc_app_mcu2_1_release.xer5f
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mpu1_0_release.xa72fg
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu2_0_release.xer5f
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu1_1_release.xer5f
	$(Q)echo "------> Env setup done !!!";
	$(Q)echo "------> Flow below step to run on J721e EVM !!!";
	$(Q)echo "		Connect to MAIN R5 0 1 (MAIN_Cortex_R5_0_1)"
	$(Q)echo "		Connect to Cortex A72 0 0"
	$(Q)echo "		Connect to MAIN R5 0 0 (MAIN_Cortex_R5_0_0)"
	$(Q)echo "		Connect to MCU R5 1 1 (MCU_Cortex_R5_0_1)"
	$(Q)echo "		Load MCAL example application cdd_ipc_app_mcu2_1_release.xer5f available at into MAIN CORTEX R5 1"
	$(Q)echo "		Load Remote example application ipc_remote_app_mpu1_0_release.xer5f available at into Cortex A72 0 0"
	$(Q)echo "		Load Remote example application ipc_remote_app_mcu2_0_release.xer5f available at into MAIN R5 0 0"
	$(Q)echo "		Load Remote example application ipc_remote_app_mcu1_1_release.xer5f available at into MCU R5 0 1"
	$(Q)echo "		Run remote cores (A72)"
	$(Q)echo "		Run application on MCU 2 1"
	$(Q)echo "		Run remaining remote cores (MCU 2 0, MCU 1 1)"
	$(Q)echo "	check the log!!!"
	
mcusw-cdd-ipc-demo-linux-setup: check_paths_sd_rootfs
	$(Q)echo "start cddipc linux demo setup check";
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f
	$(Q)cd $(SD_ROOTFS) && mkdir -p $(SJ_ROOTFS)/lib/firmware/pdk-ipc
	$(Q)sudo cp $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f $(SJ_ROOTFS)/lib/firmware/pdk-ipc
	$(Q)cd $(SJ_ROOTFS)/lib/firmware/ && ls -l && ls -l ./pdk-ipc
	$(Q)echo "please run below command on linux console"
	$(Q)echo "rm /lib/firmware/j7-main-r5f0_1-fw"
	$(Q)echo "cd /lib/firmware && ln -s /lib/firmware/pdk-ipc/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f j7-main-r5f0_1-fw"
	$(Q)echo "ls /lib/firmware/  && sync"
	$(Q)echo "reboot the system!"
	$(Q)echo "root@j7-evm:~# modprobe rpmsg_client_sample count=10"
	
## SPI IPC/Communication Application
mcusw-ipc-spi-master-demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_master_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcusw_ipc_spi_master_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_master_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
mcusw_ipc_spi_slave_demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_slave_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcusw_ipc_spi_slave_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_slave_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	

## Print CCS path 
mcusw_ccs_script_path:
	$(Q)echo "SDK0703: loadJSFile(\"$(SJ_PATH_PSDKRA)/pdk_jacinto_07_03_00_29/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\")"

# SJ_MCUSS_MCU_IMAGE below two can work on SDK8.1 
# optimized for SBL --> Kernel
# development for SBL --> UBOOT --> KERNEL 
SJ_MCUSS_MCU_IMAGE=\$$\(PDK_INSTALL_PATH\)/ti/binary/ipc_echo_testb_freertos/bin/\$$\(BOARD\)/ipc_echo_testb_freertos_mcu1_0_release_strip.xer5f
#SJ_MCUSS_MCU_IMAGE=$\$$\(PDK_INSTALL_PATH\)/ti/binary/sciserver_testapp_freertos/bin/j721e/sciserver_testapp_freertos_mcu1_0_release_strip.xer5f
mcusw-sbl-boot-u-boot: 
	$(Q)$(call sj_echo_log, 0 , " --- 0. SBL boot u-boot img !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. build the pdk libs and  sbl_mmcsd_img_hlos  !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 2. build changes : HLOS_BOOT to development or optimized: $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk  !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(Q)sed -i '/^HLOS_BOOT ?=/c HLOS_BOOT ?= development'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(Q)$(call sj_echo_log, 0 , " --- 3. build changes : HLOS_BIN_PATH to PSDKLA/board-support/prebuilt-images folder:  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk  !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BIN_PATH ?=" 
	$(Q)sed -i '/^HLOS_BIN_PATH ?=/c HLOS_BIN_PATH ?= ${SJ_PATH_PSDKLA}/board-support/prebuilt-images'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BIN_PATH ?=" 
	$(Q)$(call sj_echo_log, 0 , " --- 4. KERNEL_IMG. It essentially points to A72 SPL $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk  !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "SPL_IMG    ?=" 
	$(Q)sed -i '/^SPL_IMG    ?=/c SPL_IMG    ?= load_only,$(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/spl/u-boot-spl.bin,0x80080000,0x80080000'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "SPL_IMG    ?=" 
	$(Q)$(call sj_echo_log, 0 , " --- 5. KERNEL_IMG. It essentially points to A72 SPL $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk  !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "IMG1 ?=" 
	$(Q)sed -i '/^IMG1 ?=/c IMG1 ?= mcu1_0,$(SJ_MCUSS_MCU_IMAGE)'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "IMG1 ?=" 
	$(Q)$(call sj_echo_log, 0 , " --- 6. remove the combined.appimage and rebuild   !!!");
	$(Q)if [ -f $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/bin/j721e_evm/combined.appimage ]; then \
		rm $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/bin/j721e_evm/combined.appimage; \
	fi
	cd $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/ && make
	$(Q)$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/
	$(Q)$(call sj_echo_log, 0 , " --- 7. It's ready for boot your EVM    !!!");

mcusw-sd-sbl-boot-u-boot: pdk-sbl-mmcsd-img mcusw-sbl-boot-u-boot  check_paths_sd_boot
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage             $(SJ_BOOT)/tiboot3.bin
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin                                                        $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/bin/j721e_evm/combined.appimage                     $(SJ_BOOT)/app
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 7. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");

# SPL BOOT MCU Program 
#SJ_MCUSS_MCU_PROGRAM=$(TI_SDK_PATH)/board-support/prebuilt-images/ipc_echo_testb_mcu1_0_release_strip.xer5f
#SJ_MCUSS_MCU_PROGRAM=
#SJ_MCUSS_MCU_PROGRAM=$(SJ_PATH_PDK)/packages/ti/binary/sciserver_testapp_freertos/bin/j721e/sciserver_testapp_freertos_mcu1_0_release.xer5f
#SJ_MCUSS_MCU_PROGRAM=$(SJ_PATH_PDK)/packages/ti/binary/ipc_echo_testb_freertos/bin/j721e_evm/ipc_echo_testb_freertos_mcu1_0_release.xer5f
SJ_MCUSS_MCU_PROGRAM=$(SJ_PATH_MCUSS)/binary/cdd_ipc_profile_app_rc_linux/bin/j721e_evm/cdd_ipc_profile_app_rc_linux_mcu1_0_debug.xer5f
define sj_mcusw_mcu_project
    SJ_MCU_PROJECT_PATH_PRINT=$(SJ_MCUSS_MCU_PROGRAM)
	$(1) := $$(SJ_MCU_PROJECT_PATH_PRINT)
endef
mcusw-spl-boot-mcu: 
	$(Q)$(call sj_echo_log, 0 , " --- 0. SPL Boot MCU !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. backup the Makefile !!!");
	$(Q)if [ ! -f $(SJ_PATH_PSDKLA)/Makefile.backup ]; then \
	 	cp $(SJ_PATH_PSDKLA)/Makefile $(SJ_PATH_PSDKLA)/Makefile.backup;  \
	else \
		echo  "------ $(SJ_PATH_PSDKLA)/Makefile already saved, continue ..."; \
	fi
	$(Q)$(call sj_echo_log, 0 , " --- 2. update the Makefile UBOOT_DM PATH  !!!");
	$(Q)cat $(SJ_PATH_PSDKLA)/Makefile | grep "UBOOT_DM="
	$(eval $(call sj_mcusw_mcu_project,sj_mcu_project))
	sed -i '/UBOOT_DM=/c UBOOT_DM=$(sj_mcu_project)'  $(SJ_PATH_PSDKLA)/Makefile
	$(Q)cat $(SJ_PATH_PSDKLA)/Makefile | grep "UBOOT_DM="
	$(Q)$(call sj_echo_log, 0 , " --- 3. update the tiboot3 image to SD card  !!!");

# pdk-build-clean pdk-build  mcusw-spl-boot-mcu la-uboot  check_paths_sd_boot la-sd-install-uboot
mcusw-sd-spl-boot-mcu: mcusw-spl-boot-mcu la-uboot  check_paths_sd_boot la-sd-install-uboot
	$(Q)$(call sj_echo_log, 0 , " --- 0. setup done -- please run on your EVM !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 0. please set pdk-build file : ipc_echo_testb_freertos !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");
	sync

mcusw-help:
	# SETUP for SBL build RTOS update : 
	#     1. make mcusw-sbl-mmcsd-img
	#     2. make mcusw-sd-install-sbl-mmcsd-imgs
	# SETUP for SBL build Linux update : Tested on SDK0703 , On SDK0800 On SDK0801
	#     1. make mcusw-sbl-mmcsd-img-hlos
	#     2. make mcusw-sd-install-sbl-mmcsd-imgs-hlos
	# SETUP for MCUSW Modules
	# 	make mcusw-build
	# 	make mcusw-build-configure
	# 	make mcusw-build-clean
	# CAN BOOT APP: mcusw-build-can-boot-app-mcu  SJ_BOOTMODE=$(SJ_BOOTMODE) SJ_HLOSBOOT=$(SJ_HLOSBOOT)
	# 	make mcusw-build-can-boot-app-mcu-clean
	# 	make mcusw-build-can-boot-app-mcu

	