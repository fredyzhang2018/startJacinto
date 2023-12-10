#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#

SJ_PDK_BOARD          ?= j721s2_evm
# mpu1_0, mcu1_0, mcu1_1, mcu2_0, mcu2_1, mcu3_0, mcu3_1, c66xdsp_1, c66xdsp_2, c7
SJ_PDK_CORE           ?= mcu2_0
# csl osal_nonos sciclient udma dmautils pdk_examples csl_uart_test_app csl_uart_test_app csl_i2c_led_blink_app sciserver_testapp_freertos  ipc_echo_testb_freertos boot_app_mmcsd_linux
#  pdk_libs pdk_app_libs 
SJ_PDK_MODULES        ?= pdk_examples
 # PROFILE: debug or release
SJ_PDK_BUILD_PROFILE  ?= release


pdk-build: check_paths_PSDKRA pdk-build-configure
	$(Q)$(call sj_echo_log, 0 ,"--- 0 board : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE)  ");
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build $(SJ_PDK_MODULES) SOC=$(SJ_SOC_TYPE) BOARD=$(SJ_PDK_BOARD) CORE=$(SJ_PDK_CORE) TOOLS_INSTALL_PATH=$(SJ_PDK_TOOLS_PATH) -s BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) -j$(CPU_NUM) 
	$(Q)$(call sj_echo_log, 0 ,"--- 1 build SJ_PDK_BOARD : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE) done!");

pdk-build-configure: check_paths_PSDKRA
	$(Q)echo "build configuration: $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE)  BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) "

pdk-build-clean: check_paths_PSDKRA pdk-build-configure
	$(Q)echo "board : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE)  "
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build $(SJ_PDK_MODULES)_clean SOC=j721e BOARD=$(SJ_PDK_BOARD) CORE=$(SJ_PDK_CORE) -s TOOLS_INSTALL_PATH=$(SJ_PDK_TOOLS_PATH) BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) -j$(CPU_NUM)
	$(Q)echo "build SJ_PDK_BOARD : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE) done!"

pdk-clean:
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build allclean

pdk-scrub: check_paths_PSDKRA
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build allclean
	rm -rf $(SJ_PATH_PDK)/packages/ti/binary
	rm -rf $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary
	$(MAKE) pdk-build-configure
	
pdk-sbl-mmcsd-img:
	$(Q)echo "start build sbl for mmcsd ";
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) pdk_libs      -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build BOARD=j721e_evm CORE=mcu1_0 BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) sbl_mmcsd_img -s -j$(CPU_NUM)
	$(Q)echo "test !!!";

pdk-sbl-boot-mcu-setup: check_paths_sd_boot # This command is only for boot MCU. for others, please check the MCUSW
	$(Q)$(call sj_echo_log, 0 , " --- 0. pdk-sbl-boot-setup :  setup the SBL boot !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Copy SBL binary sbl_mmcsd_img_mcu1_0_release.tiimage as tiboot3.bin !!!");
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary/j721e_evm/mmcsd/bin/sbl_mmcsd_img_mcu1_0_release.tiimage $(SJ_BOOT)/tiboot3.bin
ifeq ($(SJ_SOC_TYPE), J721E)
	$(Q)$(call sj_echo_log, 0 , " --- 2. Copy the tifs.bin form PDK/packages/ti/drv/sciclient/soc/V1/tifs.bin as tifs.bin in case of J721E !!!");
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V1/tifs.bin $(SJ_BOOT)/
else ifeq ($(SJ_SOC_TYPE), J7200)
	$(Q)$(call sj_echo_log, 0 , " --- 2. Copy the tifs.bin form PDK/packages/ti/drv/sciclient/soc/V2/tifs.bin as tifs.bin in case of J7200 !!!");
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/drv/sciclient/soc/V2/tifs.bin $(SJ_BOOT)/
endif
	$(Q)$(call sj_echo_log, 0 , " --- 3. Copy the application from /mcusw/binary/appname_app/bin/j721e_evm/appimage to the SD card boot partition as app !!!");
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/binary/sciserver_testapp_freertos/bin/j721e/sciserver_testapp_freertos_mcu1_0_debug.appimage $(SJ_BOOT)/app
	$(Q)$(call sj_echo_log, 0 , " --- 4. finish !!!");

pdk-spl-boot-mcu-setup: check_paths_sd_boot  check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, 0 , " --- 0. Copy the application from /mcusw/binary/appname_app/bin/j721e_evm/appimage to the SD card boot partition as app j7-mcu-r5f0_0-fw !!!");
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/binary/sciserver_testapp_freertos/bin/j721e/sciserver_testapp_freertos_mcu1_0_debug.xer5f $(SJ_ROOTFS)/lib/firmware/
	$(INSTALL) $(SJ_PATH_PDK)/packages/ti/binary/sciserver_testapp_freertos/bin/j721e/sciserver_testapp_freertos_mcu1_0_debug.xer5f $(SJ_ROOTFS)/lib/firmware/ipc_echo_testb_mcu1_0_release_strip.xer5f
	rm $(SJ_ROOTFS)/lib/firmware/j7-mcu-r5f0_0-fw
	#cd $(SJ_ROOTFS)/lib/firmware/ && ln -s $(SJ_ROOTFS)/lib/firmware/ipc_echo_testb_mcu1_0_release_strip.xer5f  ./j7-mcu-r5f0_0-fw

pdk-help:
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build help BOARD=$(SJ_PDK_BOARD)
	$(Q)$(ECHO) " Variable Setting : "
	$(Q)$(ECHO) "#   SJ_PDK_BOARD = $(SJ_PDK_BOARD)"
	$(Q)$(ECHO) "#   SJ_PDK_CORE  = $(SJ_PDK_CORE)"
	$(Q)$(ECHO) "#   SJ_PDK_MODULES = $(SJ_PDK_MODULES)"
	$(Q)$(ECHO) "#   SJ_PDK_BUILD_PROFILE = $(SJ_PDK_BUILD_PROFILE)"

sbl-bootimage-sd:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_pdk_sd sbl_mcusw_bootimage_sd !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_bootimage_sd -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_pdk_sd sbl_mcusw_bootimage_sd done!!!");

sbl-bootimage-emmc-boot0:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_pdk_sd sbl_bootimage_emmc_boot0 !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) 	sbl_bootimage_emmc_boot0 -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_pdk_sd sbl_bootimage_emmc_boot0 done!!!");

sbl-bootimage-emmc-uda:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_pdk_sd sbl_bootimage_emmc_uda !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) 	sbl_bootimage_emmc_uda -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_pdk_sd sbl_bootimage_emmc_uda done!!!");

sbl-bootimage-ospi:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_pdk_sd sbl_mcusw_bootimage_sd !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_bootimage_ospi -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_pdk_sd sbl_mcusw_bootimage_sd done!!!");

sbl-vision_apps-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   sbl_vision_apps_bootimage !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_vision_apps_bootimage -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.   sbl_vision_apps_bootimage done!!!");

# build the linux: dtb kernel etc 
sbl-linux-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  linux boot image !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_linux_bootimage -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  linux boot image done!!!");

# This should run on UART BOOT Mode
sbl-ospi-bootimage-install-tftp:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   update sd boot partition images for ospi boot!!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_bootimage_install_ospi -s -j$(CPU_NUM)
	cp -r $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/* /tftpboot
	ls -l /tftpboot
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.   update sd boot partition images for ospi boot--done!!!");

hs-ospi-bootimage-install-tftp:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   update sd boot partition images for ospi boot!!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_bootimage_install_ospi_hs -s -j$(CPU_NUM)
	$(Q)sync
	cp -r $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/* /tftpboot
	# ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/
	$(Q)ls -l /tftpboot
	$(Q)cp -v /tftpboot/sbl_cust_img_mcu1_0_release.tiimage.signed /tftpboot/sbl_cust_img_mcu1_0_release.tiimage
	$(Q)cp -v /tftpboot/can_boot_app_mcu_rtos_mcu1_0_release_ospi.appimage.signed /tftpboot/can_boot_app_mcu_rtos_mcu1_0_release_ospi.appimage
	$(Q)cp -v /tftpboot/tifs-hs-enc.bin  /tftpboot/tifs.bin
	$(Q)cp -v /tftpboot/lateapp1.signed  /tftpboot/lateapp1
	$(Q)cp -v /tftpboot/lateapp2.signed  /tftpboot/lateapp2
	$(Q)cp -v /tftpboot/atf_optee.appimage.signed           /tftpboot/atf_optee.appimage
	$(Q)cp -v /tftpboot/tikernelimage_linux.appimage.signed /tftpboot/tikernelimage_linux.appimage
	$(Q)cp -v /tftpboot/tidtb_linux.appimage.signed         /tftpboot/tidtb_linux.appimage
	$(Q)sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.   update sd boot partition images for ospi boot--done!!!");	


hs-sbl-bootimage-sd:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: SBL APP TIFS  !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_bootimage_sd_hs -s -j$(CPU_NUM)
	$(Q)ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: SBL APP TIFS --done  !!!");

hs-sbl-linux-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   hs linux boot image  !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_linux_bootimage_hs -s -j$(CPU_NUM)
	$(Q)ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles
	$(Q)$(call sj_echo_log, 0 , " --- 0.   hs linux boot image --done  !!!");

hs-sbl-vision-apps-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: lateapp1 lateapp2 !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_vision_apps_bootimage_hs -s -j$(CPU_NUM)
	$(Q)ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: lateapp1 lateapp2 --done !!!");

hs-sbl-linux-combined-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: combined app for linux !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_linux_combined_bootimage_hs -s -j$(CPU_NUM)
	$(Q)ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles
	$(Q)$(call sj_echo_log, 0 , " --- 0.   build the image for HS chip: combined app for linux --done !!!");

hs-sd-sbl-combined-bootimage:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   update sd card for combined image !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_combined_bootimage_install_sd_hs -s -j$(CPU_NUM)
	$(Q)ls -l  $(SJ_BOOT)
	$(Q)$(call sj_echo_log, 0 , " --- 0.   update sd card for combined image --done !!!");

hs-sd-sbl-bootimage-install-sd:
	$(Q)$(call sj_echo_log, 0 , " --- 0.   update sd boot partition images for linux boot!!!");
	$(Q)cat  $(SJ_PATH_PSDKRA)/vision_apps/vision_apps_build_flags.mak | grep "J7ES_SR?="
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD)  sbl_bootimage_hs_install_sd -s -j$(CPU_NUM)
	$(Q)cat  $(SJ_PATH_PSDKRA)/vision_apps/vision_apps_build_flags.mak | grep "J7ES_SR?="
	$(Q)ls -l  $(SJ_BOOT)
	$(Q)$(call sj_echo_log, 0 , " --- 1.   update sd boot partition images for linux boot--done!!!");

# sbl_bootimage: 
# 	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage !!!");
# 	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_bootimage 
# 	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage done!!!");

# mcusw-sbl-mmcsd-img-hlos :  kernel build 
# sbl_bootimage_sd         :  SBL boot image
# sbl_vision_apps_bootimage:  vision apps image. 
SJ_SBL_PREBUILT?=no
sbl-sd-bootimage:  check_paths_sd_boot
	$(Q)$(call sj_echo_log, 0 , " --- 0.  update boot image to SD !!!");
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tiboot3.bin $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tifs.bin    $(SJ_BOOT)
ifeq ($(SJ_SBL_PREBUILT), yes)
	$(INSTALL) $(SJ_PATH_RESOURCE)/psdkra/0801/can_boot_app_mcu_rtos_mcu1_0_release.appimage          $(SJ_BOOT)/app
else
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/app                                      $(SJ_BOOT)
endif
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/atf_optee.appimage              $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tidtb_linux.appimage            $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tikernelimage_linux.appimage    $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp1                                 $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp2                                 $(SJ_BOOT)
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.  update boot image to SD done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");
	
sbl-sd-combined-image-opt: check_paths_sd_boot
	$(Q)$(call sj_echo_log, 0 , " --- 0.  update boot image to SD !!!");
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tiboot3.bin              $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                 $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_opt.appimage    $(SJ_BOOT)/app
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.  update boot image to SD done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");


sbl-sd-combined-image-dev: check_paths_sd_boot
	$(Q)$(call sj_echo_log, 0 , " --- 0.  update boot image to SD !!!");
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tiboot3.bin              $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                 $(SJ_BOOT)
	$(INSTALL) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_dev.appimage    $(SJ_BOOT)/app
	$(INSTALL) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img                        $(SJ_BOOT)/
	$(INSTALL) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/uEnv.txt                          $(SJ_BOOT)/
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.  update boot image to SD done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");



sbl-bootimage-clean:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_bootimage_clean !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_bootimage_clean 
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_bootimage_clean !!!");

sbl-combined-bootimage-opt: 
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(Q)sed -i '/^HLOS_BOOT ?=/c HLOS_BOOT ?= optimized'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_combined_bootimage -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1. sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");


sbl-combined-bootimage-dev: 
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage !!!");
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(Q)sed -i '/^HLOS_BOOT ?=/c HLOS_BOOT ?= development'  $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk
	$(Q)cat $(SJ_PATH_PDK)/packages/ti/boot/sbl/tools/combined_appimage/config.mk | grep "HLOS_BOOT ?=" 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_linux_combined_bootimage_dev -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1. sbl_bootimage_sd sbl_bootimage_ospi sbl_atf_optee sbl_vision_apps_bootimage sbl_qnx_bootimage sbl_linux_bootimage done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");

sbl-combined-bootimage-emmc-boot0: 
	$(Q)$(call sj_echo_log, 0 , " --- 0.   atf_optee  sbl_vision_apps sbl_linux_combined_bootimage sbl_emmc_boot0 !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_combined_bootimage_emmc_boot0  -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.    atf_optee  sbl_vision_apps sbl_linux_combined_bootimage sbl_emmc_boot0 done!!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. Docs: $(SJ_PATH_JACINTO)/docs/jacinto7/jacinto7_optimization_boot_flow.md done !!! ");

sbl-combined-bootimage-install-sd:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_bootimage_clean !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_combined_bootimage_install_sd  -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_bootimage_clean !!!");

sbl-combined-bootimage-clean:
	$(Q)$(call sj_echo_log, 0 , " --- 0.  sbl_combined_bootimage_clean !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sbl_combined_bootimage_clean -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 1.  sbl_combined_bootimage_clean !!!");

sbl-help:
	# sbl_bootimage_sd
	# sbl_bootimage_install_sd
	# sbl_bootimage_clean
	# sbl_bootimage_clean
	# sbl-linux-combined-bootimage
	# sbl_combined_bootimage_install_sd
	# sbl_combined_bootimage_clean
	

# ------------------------------------------------------
# # PDK make help
# ------------------------------------------------------
# make -s [OPTIONAL MAKE VARIABLES] Note: use gmake for windows

# Supported targets:
# ------------------
# all            : Builds all libraries and examples for the provided CORE and BOARD
# allcores       : Builds all libraries and examples for all applicable CORES for a BOARD
# clean          : Cleans all libraries and examples for the provided CORE and BOARD
# allcores_clean : Cleans all libraries and examples for all applicable CORES for a BOARD
# allclean       : Removes the binary directory using rm -rf
# pdk_examples   : Builds all examples
# pdk_libs       : Builds all libraries
# pdk_app_libs   : Builds all application utility libaries
# custom_target  : Builds the target list provided by BUILD_TARGET_LIST_ALL= for all cores and profiles
# <Module>       : Builds a module. Possible values:
# [ csl_init csl_intc csl csl_utils_common csl_uart_console board pm_hal pm_hal_optimized pm_lib pm_lib_optimized pm_rtos  pmic sbl_lib_mmcsd sbl_lib_ospi sbl_lib_uart sbl_lib_hyperflash sbl_lib_cust 
# sbl_lib_mmcsd_hlos sbl_lib_ospi_hlos sbl_lib_hyperflash_hlos sbl_lib_ospi_nondma sbl_lib_ospi_nondma_hlos sbl_lib_mmcsd_hs sbl_lib_ospi_hs sbl_lib_uart_hs sbl_lib_hyperflash_hs sbl_lib_cust_hs 
# sbl_lib_mmcsd_hlos_hs sbl_lib_ospi_hlos_hs sbl_lib_hyperflash_hlos_hs sbl_lib_ospi_nondma_hs sbl_lib_ospi_nondma_hlos_hs  udma dmautils udma_apputils lpm  enet enetsoc enetphy lwipif_freertos 
# lwipific_freertos enet_intercore enet_cfgserver enet_example_utils_freertos enet_example_utils_full_freertos enet_example_utils_baremetal  lwipcontrib_freertos lwipstack_freertos lwipport_freertos  
# csirx  csitx fvid2  dss cal sciclient sciclient_hs rm_pm_hal sciserver_tirtos sciserver_freertos sciserver_baremetal sciclient_direct sciclient_direct_hs  vhwa iolink iolink_indp iolink_profile iolink_profile_indp 
# sdr ipc ipc_baremetal osal_nonos osal_nonos_indp osal_freertos i2c i2c_indp i2c_profile i2c_profile_indp i2c_icss0 uart uart_dma uart_indp uart_console usb serdes_diag gpio gpio_indp gpio_profile gpio_profile_indp 
# copyvecs timeSync  timeSync_hal timeSync_ptp nimu nimu_profile nimu_icssg nimu_icssg_profile fatfs_indp fatfs_multi_indp mmcsd mmcsd_dma mmcsd_indp pcie pcie_indp mcasp mcasp_indp mcbsp icss_emac icss_emac_indp pruss 
# pruss_indp spi spi_dma spi_indp gpmc gpmc_dma gpmc_profile gpmc_dma_profile gpmc_indp gpmc_profile_indp salite2 crc gpadc hwa edma mailbox mibspi mibspi_dma canfd freertos esm watchdog adcbuf cbuff]

# <Module_App_lib> : Builds application libraries:
# [ pm_example_utils  dss_app_utils dss_app_utils_sysbios  cal_app_utils_baremetal]

# <Module_App>   : Builds an application. Possible values:
# [  csl_dss_display_app csl_dss_colorbar_app csl_edma_test_app csl_i2c_led_blink_app csl_mailbox_sender_receiver_app csl_mailbox_ipc_app csl_uart_test_app csl_uart_intr_test_app csl_uart_edma_test_app 
# csl_mcasp_transmit_app csl_mcspi_masterslave_app csl_mcspi_masterPerformance_app csl_baremetal_mcspi_masterPerformance_app csl_spinlock_test_app csl_gpio_toggle_app csl_gpio_interrupt_app 
# csl_xmc_mpu_test_app csl_mmc_raw_access_app csl_dcan_loopback_app csl_qspi_test_app csl_ospi_flash_app memory_benchmarking_app_freertos csl_nor_read_write_app csl_fpga_read_write_app csl_wdtimer_reset_app 
# csl_timer_app csl_pcie_ep_write_loopback_app csl_pcie_rc_write_loopback_app csl_mmu_tlb_twl_app csl_mmu_a15_data_validation_app csl_mmu_translation_fault_handle_app csl_crc_semicpu_test_app 
# csl_crc_cputest_app csl_ecc_test_app csl_ocmc_basic_test_app csl_esm_eve_reset_test_app csl_esm_clk_loss_test_app csl_dcc_singleshotmode_app csl_rti_dwwd_test_app csl_adc_singleshot_test_app 
# csl_epwm_duty_cycle_test_app csl_ecap_epwm_loopback_test_app csl_ecap_apwm_test_app csl_eqep_capture_test_app csl_hyperbus_app csl_mcan_evm_loopback_app csl_ddr_test_app csl_ccmr5_baremetal_test_app 
# csl_vim_baremetal_test_app csl_core_r5_baremetal_test_app csl_dmTimer_baremetal_test_app csl_cbass_baremetal_test_app csl_ecc_aggr_baremetal_test_app csl_esm_baremetal_test_app csl_lbist_test_app csl_pbist_test_app 
# csl_fsi_test_app csl_vtm_pvt_sensor_read csl_vtm_pvt_sensor_maxt_outrg csl_vtm_pvt_sensor_temp_alert csl_vtm_ut_baremetal_app csl_pok_ut_baremetal_app csl_stog_test_app csl_r5_mpu_tcm_app  csl_mcan_unit_test_app 
# csl_mcan_unit_test_app_freertos csl_dcc_unit_testapp csl_crc_unit_testapp csl_rti_unit_testapp csl_rtitmr_unit_testapp csl_adc_unit_testapp  board_ddr_thermal_test_app_freertos board_baremetal_ddr_thermal_test_app  
# pm_baremetal_systemconfig_testapp pm_arp32_cpuidle_testapp pm_baremetal_clkrate_testapp pm_baremetal_voltage_read_testapp pm_cpuidle_testapp pm_baremetal_junction_temp_testapp pm_ina226_testapp pm_core_loading_testapp  
# pmic_rtc_testapp pmic_gpio_testapp pmic_power_testapp pmic_wdg_testapp pmic_misc_testapp pmic_esm_testapp pmic_fsm_testapp pmic_benchmark_testapp pmic_stress_testapp sbl_uart_img sbl_mmcsd_img sbl_mmcsd_img_hlos 
# sbl_ospi_img sbl_ospi_img_hlos sbl_hyperflash_img sbl_hyperflash_img_hlos sbl_mmcsd_img_hs sbl_ospi_img_hs sbl_hyperflash_img_hs sbl_uart_img_hs sbl_mmcsd_img_hlos_hs sbl_ospi_img_hlos_hs sbl_hyperflash_img_hlos_hs 
# sbl_boot_test_ordered sbl_multicore_amp_ordered sbl_boot_test_short sbl_multicore_amp_short sbl_boot_test sbl_multicore_amp sbl_smp_test sbl_multicore_smp sbl_boot_xip_test sbl_boot_xip_entry sbl_boot_multicore_xip_entry 
# sbl_cust_img sbl_cust_img_hs sbl_boot_perf_test keywriter_img  dmautils_baremetal_autoincrement_testapp dmautils_baremetal_autoinc_1d2d3d_testapp dmautils_baremetal_autoinc_circular_testapp udma_memcpy_testapp_freertos 
# udma_baremetal_memcpy_testapp udma_chaining_testapp_freertos udma_sw_trigger_testapp_freertos udma_dru_testapp_freertos udma_dru_direct_tr_testapp_freertos udma_crc_testapp_freertos udma_adc_testapp_freertos 
# udma_baremetal_ospi_flash_testapp  udma_unit_testapp_freertos udma_user_input_unit_testapp_freertos udma_baremetal_unit_testapp udma_dynamic_unit_testapp  lpm_example_freertos io_retention_freertos  
# enet_lwip_example_freertos enet_loopback_test_freertos enet_multiport_test_freertos enet_tas_test_freertos  enet_unit_testapp_freertos enet_icssg_unit_testapp_freertos  csirx_capture_testapp_freertos 
# csirx_baremetal_capture_testapp  csirx_unit_testapp_freertos  csitx_transmit_testapp_freertos  dss_colorbar_testapp_freertos dss_display_testapp_freertos dss_baremetal_display_testapp dss_m2m_testapp_freertos  
# cal_baremetal_capture_testapp cal_baremetal_loopback_testapp  sciclient_firmware_boot_TestApp sciclient_ccs_init sciclient_rtos_app_freertos sciclient_unit_testapp_freertos sciserver_testapp_freertos 
# sciclient_fw_testapp_freertos  vhwa_msc_baremetal_testapp vhwa_msc_testapp_freertos vhwa_ldc_baremetal_testapp vhwa_ldc_testapp_freertos vhwa_dof_baremetal_testapp vhwa_dof_testapp_freertos vhwa_viss_baremetal_testapp 
# vhwa_viss_testapp_freertos vhwa_nf_baremetal_testapp vhwa_nf_testapp_freertos vhwa_sde_baremetal_testapp vhwa_sde_testapp_freertos vhwa_int_baremetal_testapp vhwa_flexconnect_baremetal_testapp  sdr_test  
# diag_ex_esm_example_app diag_ex_wwdt_perm_example_app diag_ex_wwdt_perm_fifty_example_app diag_ex_wwdt_early_example_app diag_ex_wwdt_late_example_app diag_ex_wwdt_perm_example_app_multicore 
# diag_ex_wwdt_perm_fifty_example_app_multicore diag_ex_wwdt_early_example_app_multicore diag_ex_wwdt_late_example_app_multicore diag_ex_ecc_example_app  
# ipc_echo_test_freertos ipc_echo_baremetal_test ipc_echo_testb_freertos ipc_echo_baremetal_testb ex01_bios_2core_echo_test_freertos ex02_bios_multicore_echo_test_freertos ex02_baremetal_multicore_echo_test 
# ex05_bios_multicore_echo_negative_test_freertos ex02_bios_multicore_echo_testb_freertos ex03_linux_bios_2core_echo_test_freertos ipc_perf_test_freertos ex04_linux_baremetal_2core_echo_test  
# OSAL_TestApp_freertos OSAL_Baremetal_TestApp drv_i2c_led_blink_test I2C_Baremetal_Eeprom_TestApp drv_i2c_utility I2C_Master_TestApp  I2C_Slave_TestApp I2C_Eeprom_TestApp_freertos UART_Baremetal_TestApp 
# UART_Baremetal_DMA_TestApp UART_TestApp_freertos UART_DMA_TestApp_freertos  USB_HostMsc_usb30_TestApp USB_HostMsc_TestApp_freertos USB_DevMsc_TestApp_freertos USB_DevBulk_TestApp_freertos 
# USB_HostMsc_usb30_TestApp_freertos serdes_diag_BER_app serdes_diag_EYE_app GPIO_Baremetal_LedBlink_TestApp GPIO_LedBlink_TestApp_freertos NIMU_Cpsw_ExampleApp NIMU_Cpsw_SMP_ExampleApp 
# NIMU_FtpCpsw_ExampleApp NIMU_Icssg_ExampleApp NIMU_FtpIcssg_ExampleApp  FATFS_Console_TestApp_freertos  MMCSD_TestApp_freertos MMCSD_EMMC_TestApp_freertos MMCSD_EMMC_DMA_TestApp_freertos 
# MMCSD_DMA_TestApp_freertos MMCSD_Regression_TestApp_freertos MMCSD_EMMC_Regression_TestApp_freertos MMCSD_Baremetal_TestApp MMCSD_Baremetal_DMA_TestApp MMCSD_Baremetal_EMMC_TestApp 
# MMCSD_Baremetal_EMMC_DMA_TestApp MMCSD_Baremetal_Regression_TestApp MMCSD_EMMC_Baremetal_Regression_TestApp  PCIE_sample_ExampleProject_freertos PCIE_Qos_ExampleProject_freertos PCIE_ssd_ExampleProject  
# MCASP_DeviceLoopback_TestApp_freertos pruss_app_sorte_slave pruss_app_sorte_master drv_mcspi_loopback_app MCSPI_Baremetal_Master_TestApp MCSPI_Baremetal_Slave_TestApp MCSPI_Baremetal_Master_Dma_TestApp 
# MCSPI_Baremetal_Slave_Dma_TestApp OSPI_Baremetal_Flash_TestApp  OSPI_Baremetal_Flash_Dma_TestApp OSPI_Flash_TestApp OSPI_Flash_Dma_TestApp OSPI_Baremetal_Flash_Cache_TestApp  
# OSPI_Baremetal_Flash_Dma_Cache_TestApp OSPI_Flash_Cache_TestApp OSPI_Flash_Dma_Cache_TestApp QSPI_Baremetal_Flash_TestApp QSPI_Baremetal_Flash_Dma_TestApp QSPI_FileFlashWrite_Dma_TestApp 
# MCSPI_Master_TestApp_freertos MCSPI_Slave_TestApp_freertos MCSPI_Master_Dma_TestApp_freertos MCSPI_Slave_Dma_TestApp_freertos OSPI_Flash_TestApp_freertos OSPI_Flash_Dma_TestApp_freertos 
# OSPI_Flash_Cache_TestApp_freertos OSPI_Flash_Dma_Cache_TestApp_freertos QSPI_Flash_TestApp_tirtos QSPI_Flash_TestApp_freertos QSPI_Flash_Dma_TestApp_tirtos QSPI_Flash_Dma_TestApp_freertos GPMC_Baremetal_TestApp GPMC_TestApp 
# GPMC_Baremetal_Dma_TestApp GPMC_Dma_TestApp GPMC_Baremetal_Probing_Example  SA_Baremetal_TestApp SA_TestApp_freertos  crc_testapp_freertos  gpadc_test_freertos  hwa_testapp_freertos  edma_baremetal_memcpy_testapp 
# edma_memcpy_testapp_freertos edma_unit_testapp_freertos  mailbox_msg_testapp_freertos mailbox_perf_testapp mailbox_baremetal_perf_testapp MIBSPI_Slavemode_TestApp MIBSPI_Slavemode_Dma_TestApp 
# MIBSPI_Loopback_TestApp_freertos MIBSPI_Loopback_Dma_TestApp_freertos  canfd_test_freertos freertos_test_task_switch freertos_test_ut freertos_test_posix  watchdog_testapp_freertos  
# adcbuf_test_freertos  cbuff_manual_test_freertos  board_utils_uart_flash_programmer board_utils_uart_flash_programmer_hs  board_diag_adc board_diag_automationHeader board_diag_bootEeprom 
# board_diag_boostGpio board_diag_bootSwitch board_diag_button board_diag_clockGen board_diag_cpsw board_diag_csirx board_diag_csirx_tirtos board_diag_currentMonitor board_diag_displayPort 
# board_diag_dsi board_diag_dsitx board_diag_eeprom board_diag_emmc board_diag_expHeader board_diag_extRtc board_diag_fpdLib board_diag_framework board_diag_gpmc board_diag_hdmi board_diag_hyperbus 
# board_diag_enetIcssg board_diag_lcd board_diag_led board_diag_ledIndustrial board_diag_leoPmicLib board_diag_lin board_diag_mcan board_diag_mem board_diag_mmcsd board_diag_norflash board_diag_oledDisplay 
# board_diag_ospi board_diag_pcie board_diag_pmic board_diag_rotarySwitch board_diag_rs485Uart board_diag_spiEeprom board_diag_temperature board_diag_uart board_diag_usbDevice board_diag_usbHost board_diag_img   
# csl_mailbox_ipc_multicore_app  ipc_multicore_perf_test_freertos mailbox_baremetal_multicore_perf_testapp mailbox_multicore_perf_testapp]

# <Utils>        : Runs utilities which generate code. Possible values:
# [ sciclient_boardcfg sciclient_boardcfg_hs ]

# Optional make variables:
# ------------------------
# BOARD=[evmDRA72x evmDRA75x evmDRA78x evmAM572x idkAM572x idkAM571x idkAM574x  j721e_sim j721e_hostemu j721e_ccqt j721e_loki j721e_qt j721e_vhwazebu j721e_evm j7200_sim j7200_hostemu j7200_evm j721s2_evm am64x_evm am64x_svb am65xx_sim am65xx_evm am65xx_idk tpr12_evm tpr12_qt awr294x_evm  am64x_evm am64x_svb]
#     Default: j721e_evm
# CORE=[mpu1_0 mcu1_0 mcu1_1 mcu2_0 mcu2_1 mcu3_0 mcu3_1 c66xdsp_1 c66xdsp_2 c7x_1 mpu1_1]
#     Default: mcu1_0
# BUILD_PROFILE=[release debug]
#     Default: release
# OS=[Windows_NT linux]
#     Default: Windows_NT
#     COMP = 
#     PDK_INSTALL_PATH = /ti/j7/workarea/pdk/packages
#     XDC_INSTALL_PATH = /ti/j7/workarea/xdctools_3_61_04_40_core