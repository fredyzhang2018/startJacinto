##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################

# ## Can Profiling Application
mcuss-sbl-mmcsd-img:
	$(Q)echo "start build sbl for mmcsd ";
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release pdk_libs      -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release sbl_mmcsd_img -s -j$(CPU_NUM)
	cd $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/ && ./makemulticore.sh j721e_evm
	$(Q)echo "test !!!";
mcuss-sd-install-sbl-mmcsd-imgs: check_paths_sd_boot mcuss-sbl-mmcsd-img mcuss-can-boot-app-mcu-rtos-SD_RTOS_IMAGES
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage             $(SJ_BOOT)/tiboot3.bin
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin                                                        $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/binary/can_boot_app_mcu_rtos/bin/j721e_evm/can_boot_app_mcu_rtos_mcu1_0_release.appimage       $(SJ_BOOT)/app
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MCU2_0_MCU2_1_stage1.appimage         $(SJ_BOOT)/lateapp1
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_DSPs_MCU3_0_MCU3_1_stage2.appimage    $(SJ_BOOT)/lateapp2
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MPU1_0_stage3.appimage                $(SJ_BOOT)/lateapp3
	echo "install done"
	echo "run on evm ------> "
	echo "      1. MCU UART port, channel #2 (i.e. second UART instance) - MCU R5F CAN Boot Application logs "
	echo "      2. Main UART port, channel #1 (i.e. third UART instance) - Linux/QNX boot logs (only if Linux/QNX build enabled)"
	echo "      3. Main UART port, channel #2 (i.e. fourth UART instance) - Main Domain RTOS application logs "


mcuss-sbl-mmcsd-img-hlos:
	$(Q)echo "start build sbl for mmcsd ";
	echo "please make sure below variable:"
	echo "       1. $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/constructappimageshlos.sh"
	echo "       2. setting "OS" and Linux-specific, set linux path : "
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release pdk_libs      -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=release sbl_mmcsd_img -s -j$(CPU_NUM)
	cd $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/scripts/hlos/ && ./constructappimageshlos.sh j721e_evm
	$(Q)echo "test !!!";
mcuss-sd-install-sbl-mmcsd-imgs-hlos: check_paths_sd_boot mcuss-sbl-mmcsd-img-hlos  mcuss-can-boot-app-mcu-rtos-SD_HLOS_IMAGES
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage             $(SJ_BOOT)/tiboot3.bin
	$(Q)cp $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin                                                        $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/binary/can_boot_app_mcu_rtos/bin/j721e_evm/can_boot_app_mcu_rtos_mcu1_0_release.appimage       $(SJ_BOOT)/app
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MCU2_0_MCU2_1_stage1.appimage         $(SJ_BOOT)/lateapp1
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_DSPs_MCU3_0_MCU3_1_stage2.appimage    $(SJ_BOOT)/lateapp2
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/multicore_MPU1_0_stage3.appimage                $(SJ_BOOT)/lateapp3
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/atf_optee.appimage                              $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tidtb_linux.appimage                            $(SJ_BOOT)/
	$(Q)cp $(SJ_PATH_MCUSS)/mcuss_demos/boot_app_mcu_rtos/main_domain_apps/binary/bin/j721e_evm/tikernelimage_linux.appimage                    $(SJ_BOOT)/	
	echo "install done"
	echo "run on evm ------> "
	echo "      1. MCU UART port, channel #2 (i.e. second UART instance) - MCU R5F CAN Boot Application logs "
	echo "      2. Main UART port, channel #1 (i.e. third UART instance) - Linux/QNX boot logs (only if Linux/QNX build enabled)"
	echo "      3. Main UART port, channel #2 (i.e. fourth UART instance) - Main Domain RTOS application logs "

## Can Profiling Application
mcuss-can-boot-app-mcu-rtos-SD_RTOS_IMAGES:
	$(Q)echo "start build the can_boot_app_mcu_rtos";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_boot_app_mcu_rtos BOOTMODE=mmcsd BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_can_profile_app --done Binary-$(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
	$(Q)echo "Binary debug with CCS---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/can_boot_app_mcu_rtos/bin/j721e_evm!!!";
## Can Profiling Application
mcuss-can-boot-app-mcu-rtos-SD_HLOS_IMAGES:
	$(Q)echo "start build the can_boot_app_mcu_rtos";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build  can_boot_app_mcu_rtos HLOSBOOT=linux BOOTMODE=mmcsd BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "Binary debug with CCS---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/can_boot_app_mcu_rtos/bin/j721e_evm!!!";
mcuss-can-boot-app-mcu-rtos-SD_HLOS_IMAGES_clean:
	$(Q)echo "start build the can_boot_app_mcu_rtos";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build  can_boot_app_mcu_rtos_clean HLOSBOOT=linux BOOTMODE=mmcsd BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "Binary debug with CCS---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/can_boot_app_mcu_rtos/bin/j721e_evm!!!";
## Can Profiling Application
mcuss-can-profile-app:
	$(Q)echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_can_profile_app --done Binary-$(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
	$(Q)echo "Binary debug with CCS---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/mcuss_can_profile_app/bin/j721e_evm!!!";
mcuss-can-profile-app-clean:
	$(Q)echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_can_profile_app --done !!!";	 

## IPC Profiling Application
mcuss-cdd-ipc-profile-app:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_profile_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app --done !!!";	 
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss-cdd-ipc-profile-app-clean:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean --done !!!";	 

## CDD IPC 
mcuss-cdd-ipc-app:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_app CORE=mcu2_1 BOARD=j721e_evm SOC=j721e -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app --done !!!";	 
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app/bin/j721e_evm/cdd_ipc_app_mcu2_1_release.xer5f !!!";
	ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app/bin/j721e_evm/cdd_ipc_app_mcu2_1_release.xer5f
mcuss-cdd-ipc-app-clean:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_app_clean CORE=mcu2_1 BOARD=j721e_evm SOC=j721e  -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean --done !!!";	
mcuss-cdd-ipc-app-rc-linux:
	$(Q)echo "start build the cdd_ipc_app_rc_linux";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_app_rc_linux CORE=mcu2_1 BOARD=j721e_evm SOC=j721e -s -j$(CPU_NUM)
	$(Q)echo "start build the cdd_ipc_app_rc_linux --done !!!";	 
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f!!!";
	ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f
	
mcuss-cdd-ipc-app-rc-linux-clean:
	$(Q)echo "start build the cdd_ipc_app_rc_linux_clean";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build cdd_ipc_app_rc_linux_clean CORE=mcu2_1 BOARD=j721e_evm SOC=j721e -s -j$(CPU_NUM)
	$(Q)echo "start build the cdd_ipc_app_rc_linux_clean --done !!!";	 

### CDD IPC ccs setup demo
mcuss-cdd-ipc-demo-ccs-setup:
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
	
mcuss-cdd-ipc-demo-linux-setup: check_paths_sd_rootfs
	$(Q)echo "start ccs demo setup check";
	$(Q)ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f
	$(Q)cd $(SD_ROOTFS) && mkdir -p $(SJ_ROOTFS)/lib/firmware/pdk-ipc
	$(Q)cp $(SJ_PATH_PSDKRA)/mcusw/binary/cdd_ipc_app_rc_linux/bin/j721e_evm/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f $(SJ_ROOTFS)/lib/firmware/pdk-ipc
	$(Q)cd $(SJ_ROOTFS)/lib/firmware/ && ls -l && ls -l ./pdk-ipc 
	$(Q)echo "please run below command on linux console"
	$(Q)echo "rm /lib/firmware/j7-main-r5f0_1-fw"
	$(Q)echo "cd /lib/firmware && ln -s /lib/firmware/pdk-ipc/cdd_ipc_app_rc_linux_mcu2_1_release.xer5f j7-main-r5f0_1-fw"
	$(Q)echo "ls /lib/firmware/  && sync"
	$(Q)echo "reboot the system!"
	$(Q)echo "root@j7-evm:~# modprobe rpmsg_client_sample count=10"
	
## ipc_remote_app ----CORE mpu1_0 mcu2_1 
mcuss-ipc-remote-app:
	$(Q)echo "start build the mcuss_ipc_remote_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app CORE=mpu1_0 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mpu1_0_release.xa72fg!!!";
	ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mpu1_0_release.xa72fg
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app CORE=mcu2_0 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu2_0_release.xer5f!!!";
	ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu2_0_release.xer5f
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app CORE=mcu1_1 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu1_1_release.xer5f!!!";
	ls -l $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm/ipc_remote_app_mcu1_1_release.xer5f
	$(Q)echo "start build the mcuss_ipc_remote_app --done !!!";	 
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/ipc_remote_app/bin/j721e_evm!!!";
mcuss-ipc-remote-app-clean:
	$(Q)echo "start build the mcuss_ipc_remote_app_clean";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app_clean CORE=mpu1_0 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app_clean CORE=mcu2_0 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_remote_app_clean CORE=mcu1_1 BOARD=j721e_evm BUILD_PROFILE=release SOC=j721e BUILD_OS_TYPE=tirtos  -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_ipc_remote_app_clean --done !!!";	

## SPI IPC/Communication Application
mcuss-ipc-spi-master-demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_master_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_ipc_spi_master_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_master_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
mcuss_ipc_spi_slave_demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_slave_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(SJ_PATH_PSDKRA)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_ipc_spi_slave_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build ipc_spi_slave_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	

## Print CCS path 
mcuss_ccs_script_path:
	$(Q)echo "SDK0703: loadJSFile(\"$(SJ_PATH_PSDKRA)/pdk_jacinto_07_03_00_29/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\") "
