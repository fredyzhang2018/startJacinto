#==============================================================================
# Makefile 
# Modified for projects Jacinto7 project
# By Fredy
# 2020-11-13
#==============================================================================
#==============================================================================
# Below is configured by env setup, please checked that.
#==============================================================================
#~ PSDKRA_PATH    ?= /home/fredy/j7/psdk_rtos_auto_j7_07_00_00_11
#~ PSDKLA_PATH    ?= /home/fredy/j7/ti-processor-sdk-linux-automotive-j7-evm-07_00_01
#~ PROJECT        ?= Jacinto7_700
#~ WORK_PATH      ?= $(pwd)
#~ jacinto_PATH   ?= /home/fredy/install/jacinto7
#==============================================================================
# Common Env
#==============================================================================
BOOT                       ?= /media/`whoami`/BOOT
BOOT1                      ?= /media/`whoami`/boot
ROOTFS                     ?= /media/`whoami`/rootfs
resouce_PATH               ?= $(jacinto_PATH)/resource
INSTALLER                  ?= $(jacinto_PATH)/downloads
SCRIPTS_PATH               ?= $(jacinto_PATH)/scripts
DOWNLOADS_PATH             ?= $(jacinto_PATH)/downloads
J7_SDK_PATH                ?= $(jacinto_PATH)/sdks
J6_SDK_PATH                ?= $(jacinto_PATH)/sdks
TEST_PATH                  ?= $(jacinto_PATH)/sdks
export BOOT
export BOOT1
export ROOTFS
#==============================================================================
# Debug use
#==============================================================================
PROFILE=debug

#==============================================================================
# PSDKRA PATH
#==============================================================================
VX_TEST_DATA_PATH          ?= $(PSDKRA_PATH)/tiovx/conformance_tests/test_data
MCUSS_PATH                 ?= $(PSDKRA_PATH)/mcusw
Imaging_PATH               ?= $(PSDKRA_PATH)/imaging
VISION_SDK_BUILD_PATH      ?= $(PSDKRA_PATH)/vision_apps
TUTORIAL_RUN_PATH          ?= $(PSDKRA_PATH)/tiovx/out/PC/x86_64/LINUX/
PDK_PATH                   ?= $(PSDKRA_PATH)/`ls $(PSDKRA_PATH) | grep pdk`
export PDK_PATH
#==============================================================================
# PSDKLA PATH
#==============================================================================
K3_BOOTSWITCH_PATH         ?= $(PSDKLA_PATH)/board-support/host-tools/k3-bootswitch/
#==============================================================================
# print env
#==============================================================================
print_env:
	$(Q)$(ECHO) "### -------------env setup------------------------------"
	$(Q)$(ECHO) "# PROJECT and Username:            $(PROJECT)  $(USERNAME)"
	$(Q)$(ECHO) "# PSDKRA_PATH:                     $(PSDKRA_PATH)"
	$(Q)$(ECHO) "# PSDKLA_PATH:                     $(PSDKLA_PATH)"
	$(Q)$(ECHO) "# jacinto_PATH:                    $(jacinto_PATH)"
	$(Q)$(ECHO) "# J7_SDK_PATH                      $(J7_SDK_PATH)"	
	$(Q)$(ECHO) "# J6_SDK_PATH                      $(J6_SDK_PATH)"	
	$(Q)$(ECHO) "-------------Common Env------------------------------"
	$(Q)$(ECHO) "# BOOT BOOT1 and ROOTFS:           $(BOOT) $(BOOT1) $(ROOTFS)"
	$(Q)$(ECHO) "# resouce_PATH:                    $(resouce_PATH)"
	$(Q)$(ECHO) "# INSTALLER:                       $(INSTALLER)"
	$(Q)$(ECHO) "# SCRIPTS_PATH:                    $(SCRIPTS_PATH)"
	$(Q)$(ECHO) "# DOWNLOADS_PATH                   $(DOWNLOADS_PATH)"
	$(Q)$(ECHO) "# TEST_PATH:                       $(TEST_PATH)"		
	$(Q)$(ECHO) "-------------debug use------------------------------"
	$(Q)$(ECHO) "# PROFILE:                         $(PROFILE)"
	$(Q)$(ECHO) "-------------PSDKRA PATH------------------------------"	
	$(Q)$(ECHO) "# VX_TEST_DATA_PATH:               $(VX_TEST_DATA_PATH)"
	$(Q)$(ECHO) "# MCUSS_PATH:                      $(MCUSS_PATH)"
	$(Q)$(ECHO) "# PDK_PATH:                        $(PDK_PATH)"
	$(Q)$(ECHO) "# Imaging_PATH:                    $(Imaging_PATH)"
	$(Q)$(ECHO) "# VISION_SDK_BUILD_PATH:           $(VISION_SDK_BUILD_PATH)"
	$(Q)$(ECHO) "# TUTORIAL_RUN_PATH:               $(TUTORIAL_RUN_PATH)"
	$(Q)$(ECHO) "-------------PSDKRA PATH------------------------------"	
	$(Q)$(ECHO) "# K3_BOOTSWITCH_PATH:               $(K3_BOOTSWITCH_PATH)"
	$(Q)$(ECHO) "### ----------------------ending------------------------" 
