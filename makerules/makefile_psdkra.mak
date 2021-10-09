########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
ra-sdk:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk       -s -j$(CPU_NUM)

ra-sdk-scrub:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_scrub -s -j$(CPU_NUM)

ra-sdk-help:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_help -s -j$(CPU_NUM)
	
ra-vision_apps:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps -s -j$(CPU_NUM)

ra-vision_apps_scrub:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps_scrub -s -j$(CPU_NUM)

ra-vision_apps_clean:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps_clean -s -j$(CPU_NUM)
	
ra-sdk_show_config:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_show_config -s -j$(CPU_NUM)
##########################################
#                                        #
# imaging                                #
#                                        #
##########################################
ra-imaging:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging -s -j$(CPU_NUM)
ra-imaging-clean:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging_clean -s -j$(CPU_NUM)
ra-imaging-scrub: 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging_scrub -s -j$(CPU_NUM)
 
##########################################
#                                        #
# pdk                                    #
#                                        #
##########################################
ra-pdk:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk -s -j$(CPU_NUM)
ra-pdk-clean:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk_clean -s -j$(CPU_NUM)
ra-pdk-scrub: 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk_scrub -s -j$(CPU_NUM)
	
##########################################
#                                        #
# ethfw                                  #
#                                        #
##########################################
ra-ethfw:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw -s -j$(CPU_NUM)
ra-ethfw-clean:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw_clean -s -j$(CPU_NUM)
ra-ethfw-scrub: 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw_scrub -s -j$(CPU_NUM)

##########################################
#                                        #
# imaging                                #
#                                        #
##########################################
ra-tiovx:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx -s -j$(CPU_NUM)
ra-tiovx-clean:
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx_clean -s -j$(CPU_NUM)
ra-tiovx-scrub: 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx_scrub -s -j$(CPU_NUM)

##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################
ra-mcuss_can_profile_app:
	@echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	@echo "start build the mcuss_can_profile_app --done !!!";
	
ra-mcuss_can_profile_app_clean:
	@echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	@echo "start build the mcuss_can_profile_app --done !!!";	 


ra-sd_mcu_firmware_install:
	cp ${SJ_PATH_PSDKRA}/mcusw/binary/can_profile_app/bin/j721e_evm/can_profile_app_mcu1_0_debug.xer5f $(SJ_ROOTFS)/lib/firmware/j7-mcu-r5f0_0-fw
	ls -l  $(SJ_ROOTFS)/lib/firmware/j7-mcu-r5f0_0-fw
	sync

#
#make pdk ethfw  vision_apps

##########################################
#                                        #
# Vision-SDK Top Level Build Targets     #
#                                        #
##########################################	
#~ sd_install_video: check_paths_sd_rootfs
#~ 	@echo "rootfs install video for video testing"
#~ 	@sudo cp -r -v $(SJ_PATH_RESOURCE)/video/* $(SJ_ROOTFS)/home
#~ 	@echo "video install done!"

	
#==============================================================================
# A help message target.
#==============================================================================
ra-help:
	#
	# Use below make targets to build SDK and/or different components with the SDK
	#
	# make mmalib                # Build MMALIB (needs MMALIB source package)
	# make mmalib_clean          # Clean MMALIB (needs MMALIB source package)
	#
	# make tidl                  # Build TIDL (needs TIDL source package)
	# make tidl_clean            # Clean TIDL (needs TIDL source package)
	#
	# make ptk                   # Build PTK (needs PTK source package)
	# make ptk_clean             # Clean PTK (needs PTK source package)
	# make ptk_scrub             # Delete all generated files and folders in PTK (needs PTK source package)
	#
	# make pdk                   # Build PDK, also builds SBL
	# make pdk_clean             # Clean PDK, also cleans SBL
	# make pdk_scrub             # Delete all generated files and folders in PDK including SBL
	#
	# make tiovx                 # Build TIOVX
	# make tiovx_clean           # Clean TIOVX
	# make tiovx_scrub           # Delete all generated files and folders in TIOVX
	#
	# make imaging               # Build IMAGING
	# make imaging_clean         # Clean IMAGING
	# make imaing_scrub          # Delete all generated files and folders in IMAGING
	#
	# make remote_device         # Build remote device
	# make remote_device_clean   # Clean remote device
	# make remote_device_scrub   # Delete all generated files and folders in remote device
	#
	# make codec                 # Build video codec
	# make codec_clean           # Clean video codec
	# make codec_scrub           # Delete all generated files and folders in video codec
	#
	# make                       # Build vision apps
	# make vision_apps           # Build vision apps
	# make vision_apps_clean     # Clean vision apps
	# make vision_apps_scrub     # Delete all generated files and folders in vision apps
	#
	# make qnx                                         # Build QNX related drivers and libraries
	# make qnx_fs_install                              # Install application binaries, bootloader
	#                                                    to local host QNX target filesystem
	# make qnx_fs_install_sd                           # Copy application images from local host filesystem to SD card filesystem
	#                                                    AND copy SPL/uboot files (QNX)
	# make qnx_fs_install_sd_sbl                       # Copy application images from local host filesystem to SD card filesystem
	#                                                    AND copy SBL/MCUSW_boot_app files (QNX)
	# make qnx_fs_install_sd_test_data                 # Copy test data required for running the applications
	#                                                    to SD card filesystem. DOES NOT invoke 'qnx_fs_install_sd'
	#
	# make linux_fs_install                            # Install application binaries, dtb files, bootloader
	#                                                    and kernel images to local host linux target filesystem
	# make linux_fs_install_sd                         # Copy application images from local host filesystem to SD card filesystem
	#                                                    This also invokes 'linux_fs_install' to do a local copy before copying to SD card
	# make linux_fs_install_sd_test_data               # Copy test data required for running the applications
	#                                                    to SD card filesystem. DOES NOT invoke 'linux_fs_install_sd'
	# make linux_fs_install_nfs                        # Copy application images to local host filesystem for NFS boot
	#                                                    This also invokes 'linux_fs_install' to do a local copy
	# make linux_fs_install_nfs_test_data              # Copy test data required for running the applications using NFS boot
	#                                                    to SD card filesystem.
	#
	# make sdk_show_config       # Show SDK build variables
	# make sdk_check_paths       # Check if all paths needed by vision apps exists
	# make sdk_help              # Show supported makefile target's
	#
	# make sdk                   # Build SDK
	# make sdk_clean             # Clean SDK
	# make sdk_scrub             # Delete all generated files and folders in SDK
	#
	@echo
	@echo "Available build targets are  :"
	@echo "    ----------------print_env --------------------------------------  "
	@echo "    ----------------------------------------------------------------  "
	@echo "    ----------------Build --------------------------------------  "
	@echo "    sdk                     : To incrementally (or for the first time) build SDK"
	@echo "    sdk_scrub               : To clean SDK do below"
	@echo "    sdk_help                : To see additional build targets for SDK and component builds, do below"	
	@echo "    vision_apps             : Build all vision sdk Applications"
	@echo "    vision_apps_scrub       : Clean all vision sdk Applications"
	@echo "    sdk_show_config         : Show the config"
	@echo "    ----------------SD and SD install --------------------------------------  "
	@echo "    sd_mk_partition         : make sd partition "	
	@echo "    sd_install_boot         : install boot file to sd boot partition"	
	@echo "    sd_install_rootfs       : install filesystem to SD rootfs partition "	
	@echo "    sd_install_auto_ti_data : install auto ti data set to rootfs/opt/vision_sdk "	
	@echo "    sd_install_apps_binaries: install vision apps binaries to SD card "	
	@echo "    ----------------Turorial--------------------------------------  "
	@echo "    vx_tutorial_exe_mk     : mk vx tutorial exe"
	@echo "    vx_tutorial_exe_run    : run vx turorial exe"
	@echo	
	@echo "    ----------------Install Environment--------------------------------------  "
	@echo "    install_dependencies    : 2. install dependencies "
	@echo "    install_targetfs        : 1. run copy j7 targetfs to install dirctory"
	@echo "    install_ccs_scripts     : 3. run gel on ccs "
	@echo "    ----------------important configure flags --------------------------------------  "
	@echo "    tiovx/build_flags.mak   : These flags will affect both tiovx as well as vision_apps"
	@echo "    vision_apps/vision_apps_build_flags.mak         :  vision apps config "
	@echo "    ----------------MCUSS_build --------------------------------------  "
	@echo "    mcuss_can_profile_app  : can_profile_app "
	@echo "     "
	@echo "    ---------------- ending  !!!--------------------------------------  "

.PHONY: 
