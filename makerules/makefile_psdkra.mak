########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
##########################################
#                                        #
# MCU SDK                                #
#                                        #
##########################################
ra_mcu_all:
	$(Q)$(call sj_echo_log, info , "1. ra_mcu_all ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKRA) all  -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_mcu_all ... done!"); 
##########################################
#                                        #
# VISION SDK                             #
#                                        #
##########################################
ra_sdk:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk  -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_sdk ... done!"); 

ra_sdk_scrub:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_scrub ... done!"); 

ra_sdk_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_clean ... done!"); 

ra_sdk_help:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_help ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_help -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_help ... done!"); 
	
ra_vision_apps:
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps ... done!"); 

ra_vision_apps_scrub:
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps_scrub ... done!"); 

ra_vision_apps_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_apps_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_vision_apps_clean ... done!"); 
	
ra_sdk_show_config:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_show_config ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) sdk_show_config -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_show_config ... done!"); 
##########################################
#                                        #
# imaging                                #
#                                        #
##########################################

ra_imaging:
	$(Q)$(call sj_echo_log, info , "1. ra_imaging ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_imaging ... done!"); 
ra_imaging_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_imaging_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_imaging_clean ... done!"); 
ra_imaging_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_imaging_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) imaging_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_imaging_scrub ... done!"); 
 
ra_video_io:
	$(Q)$(call sj_echo_log, info , "1. ra_video_io ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) video_io -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_video_io ... done!"); 
ra_video_io_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_video_io_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) video_io_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_video_io_clean ... done!"); 
ra_video_io_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_video_io_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) video_io_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_video_io_scrub ... done!"); 

##########################################
#                                        #
# pdk                                    #
#                                        #
##########################################
ra_pdk:
	$(Q)$(call sj_echo_log, info , "1. ra_pdk ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_pdk ... done!"); 
ra_pdk_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_pdk_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_pdk_clean ... done!"); 
ra_pdk_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_pdk_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_pdk_scrub ... done!"); 
	
##########################################
#                                        #
# ethfw                                  #
#                                        #
##########################################
ra_ethfw:
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw ... done!"); 
ra_ethfw_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw_clean ... done!"); 
ra_ethfw_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) ethfw_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_ethfw_scrub ... done!"); 

##########################################
#                                        #
# App Utils                                  #
#                                        #
##########################################
ra_app_utils:
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) app_utils -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils ... done!"); 
ra_app_utils_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) app_utils_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils_clean ... done!"); 
ra_app_utils_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) app_utils_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_app_utils_scrub ... done!"); 

##########################################
#                                        #
# imaging                                #
#                                        #
##########################################
ra_tiovx:
	$(Q)$(call sj_echo_log, info , "1. ra_tiovx ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_tiovx ... done!"); 
ra_tiovx_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_tiovx_clean ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx_clean -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_tiovx_clean ... done!"); 
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) tiovx_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_tiovx_scrub ... done!"); 


##########################################
#                                        #
# edge ai                                #
#                                        #
##########################################

BUILD_EDGEAI=yes make sdk -j8
ra_sdk_edgeai:
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_edgeai ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) BUILD_EDGEAI=yes sdk -s -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. ra_sdk_edgeai ... done!"); 

ra_edgeai:
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) edgeai -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai ... done!"); 
ra_edgeai_install:
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai_install ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) edgeai_install -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai_install ... done!"); 
ra_edgeai_scrub: 
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai_scrub ... ");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) edgeai_scrub -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. ra_edgeai_scrub ... done!"); 

##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################
ra_mcuss_can_profile_app:
	$(Q)$(call sj_echo_log, info , "1. ra_mcuss_can_profile_app ... ");
	@echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	@echo "start build the mcuss_can_profile_app --done !!!";
	$(Q)$(call sj_echo_log, info , "1. ra_mcuss_can_profile_app ... done!"); 
	
ra_mcuss_can_profile_app_clean:
	$(Q)$(call sj_echo_log, info , "1. ra_mcuss_can_profile_app_clean ... ");
	@echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(SJ_PATH_MCUSS)/build can_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	@echo "start build the mcuss_can_profile_app --done !!!";	 
	$(Q)$(call sj_echo_log, info , "1. ra_mcuss_can_profile_app_clean ... done!"); 


ra_sd_mcu_firmware_install:
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mcu_firmware_install ... ");
	cp ${SJ_PATH_PSDKRA}/mcusw/binary/can_profile_app/bin/j721e_evm/can_profile_app_mcu1_0_debug.xer5f $(SJ_ROOTFS)/lib/firmware/j7-mcu-r5f0_0-fw
	ls -l  $(SJ_ROOTFS)/lib/firmware/j7-mcu-r5f0_0-fw
	sync
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mcu_firmware_install ... done!"); 

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
ra_help:
	$(Q)$(call sj_echo_log, info , "1. ra_help_install ... "); 
	$(Q)$(call sj_echo_log, info ,"# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "ra_mcu_all","build all ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sdk", "psdkra sdk build ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sdk_clean", "clean sdk build ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sdk_help", " psdkra sdk help ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sdk_scrub", "deleting building files ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sdk_show_config", "check the sdk config ... "); 
	$(Q)$(call sj_echo_log, help , "ra_vision_apps_scrub","build vision sdk ... "); 
	$(Q)$(call sj_echo_log, help , "ra_vision_apps_clean", "clean vision sdk ... "); 
	$(Q)$(call sj_echo_log, help , "ra_imaging","imaging building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_imaging_clean", "imaging cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_imaging_scrub", "imaging scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "ra_video"," building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_video_clean", " cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_video_scrub", " scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "ra_eth"," building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_eth_clean", " cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_eth_scrub", " scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "ra_app_utils"," building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_app_utils_clean", " cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_app_utils_scrub", " scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "ra_tiovx"," building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_tiovx_clean", " cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_tiovx_scrub", " scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "ra_edgeai"," building ... "); 
	$(Q)$(call sj_echo_log, help , "ra_edgeai_clean", " cleaning ... "); 
	$(Q)$(call sj_echo_log, help , "ra_edgeai_scrub", " scrubing ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. ra_help_install ... done!"); 


.PHONY: 
