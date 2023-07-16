#==============================================================================
# Makefile 
# Modified for projects Jacinto7 project
# By Fredy
# 2020-11-13
#==============================================================================
#==============================================================================
# Below is configured by env setup, please checked that.
#==============================================================================
#~ SJ_PATH_PSDKRA    ?= /home/fredy/j7/psdk_rtos_auto_j7_07_00_00_11
#~ SJ_PATH_PSDKLA    ?= /home/fredy/j7/ti-processor-sdk-linux-automotive-j7-evm-07_00_01
#~ SJ_PROJECT        ?= Jacinto7_700
#~ SJ_WORK_PATH      ?= $(pwd)
#~ SJ_PATH_JACINTO   ?= /home/fredy/install/jacinto7
#==============================================================================
# Common Env
#==============================================================================
SJ_BOOT                       ?= /media/`whoami`/BOOT
SJ_BOOT1                      ?= /media/`whoami`/boot
SJ_ROOTFS                     ?= /media/`whoami`/rootfs
SJ_PATH_J7_SDK                ?= $(SJ_PATH_JACINTO)/sdks
SJ_PATH_J6_SDK                ?= $(SJ_PATH_JACINTO)/sdks
SJ_PATH_TEST                  ?= $(SJ_PATH_JACINTO)/sdks
export SJ_BOOT
export SJ_BOOT1
export SJ_ROOTFS
#==============================================================================
# Debug use debug or release
#==============================================================================
SJ_PROFILE=release

#==============================================================================
# PSDKRA PATH
#==============================================================================
SJ_PATH_VX_TEST_DATA          ?= $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data
SJ_PATH_MCUSS                 ?= $(SJ_PATH_PSDKRA)/mcusw
SJ_PATH_IMAGING               ?= $(SJ_PATH_PSDKRA)/imaging
SJ_PATH_VISION_SDK_BUILD      ?= $(SJ_PATH_PSDKRA)/vision_apps
SJ_PATH_TUTORIAL_RUN          ?= $(SJ_PATH_PSDKRA)/tiovx/out/PC/x86_64/LINUX/
SJ_PATH_EDGEAI_TIDL_TOOLS     ?= $(SJ_PATH_SDK)/edgeai-tidl-tools/
SJ_PATH_PDK                   ?= $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep pdk`

export SJ_PATH_PDK
#==============================================================================
# PSDKLA PATH
#==============================================================================
SJ_PATH_K3_BOOTSWITCH         ?= $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/
#==============================================================================
# print env
#==============================================================================
print_env:
	$(Q)$(ECHO) "### -------------env setup------------------------------"
	$(Q)$(ECHO) "# SJ_PROJECT and Username:            $(SJ_PROJECT)  $(SJ_USERNAME)"
	$(Q)$(ECHO) "# SJ_PATH_PSDKRA:                     $(SJ_PATH_PSDKRA)"
	$(Q)$(ECHO) "# SJ_PATH_PSDKLA:                     $(SJ_PATH_PSDKLA)"
	$(Q)$(ECHO) "# SJ_PATH_JACINTO:                    $(SJ_PATH_JACINTO)"
	$(Q)$(ECHO) "# SJ_PATH_J7_SDK                      $(SJ_PATH_J7_SDK)"	
	$(Q)$(ECHO) "# SJ_PATH_J6_SDK                      $(SJ_PATH_J6_SDK)"	
	$(Q)$(ECHO) "# SJ_PATH_SDK                         $(SJ_PATH_SDK)"	
	$(Q)$(ECHO) "# SJ_SOC_TYPE                         $(SJ_SOC_TYPE)"	
	$(Q)$(ECHO) "-------------Common Env------------------------------"
	$(Q)$(ECHO) "# SJ_BOOT SJ_BOOT1 and SJ_ROOTFS:     $(SJ_BOOT) $(SJ_BOOT1) $(SJ_ROOTFS)"
	$(Q)$(ECHO) "# SJ_PATH_RESOURCE:                   $(SJ_PATH_RESOURCE)"
	$(Q)$(ECHO) "# SJ_PATH_SCRIPTS:                    $(SJ_PATH_SCRIPTS)"
	$(Q)$(ECHO) "# SJ_PATH_DOWNLOAD                    $(SJ_PATH_DOWNLOAD)"
	$(Q)$(ECHO) "# SJ_PATH_TEST:                       $(SJ_PATH_TEST)"		
	$(Q)$(ECHO) "-------------debug use------------------------------"
	$(Q)$(ECHO) "# SJ_PROFILE:                         $(SJ_PROFILE)"
	$(Q)$(ECHO) "-------------PSDKRA PATH------------------------------"	
	$(Q)$(ECHO) "# SJ_PATH_VX_TEST_DATA:               $(SJ_PATH_VX_TEST_DATA)"
	$(Q)$(ECHO) "# SJ_PATH_MCUSS:                      $(SJ_PATH_MCUSS)"
	$(Q)$(ECHO) "# SJ_PATH_PDK:                        $(SJ_PATH_PDK)"
	$(Q)$(ECHO) "# SJ_PATH_IMAGING:                    $(SJ_PATH_IMAGING)"
	$(Q)$(ECHO) "# SJ_PATH_VISION_SDK_BUILD:           $(SJ_PATH_VISION_SDK_BUILD)"
	$(Q)$(ECHO) "# SJ_PATH_TUTORIAL_RUN:               $(SJ_PATH_TUTORIAL_RUN)"
	$(Q)$(ECHO) "# SJ_PATH_EDGEAI_TIDL_TOOLS:          $(SJ_PATH_EDGEAI_TIDL_TOOLS)"
	$(Q)$(ECHO) "-------------PSDKRA PATH------------------------------"	
	$(Q)$(ECHO) "# SJ_PATH_K3_BOOTSWITCH:              $(SJ_PATH_K3_BOOTSWITCH)"
	$(Q)$(ECHO) "------------- User Guide   ------------------------------"	
	$(Q)$(ECHO) "# PSDKRA: http://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/latest/index_FDS.html"
	$(Q)$(ECHO) "# PSDKLA: http://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/latest/index_FDS.html"
	$(Q)$(ECHO) "# AM62xx: https://www.ti.com/product/AM625?keyMatch=&tisearch=search-everything&usecase=partmatches"
	$(Q)$(ECHO) "# AM62Ax: https://www.ti.com/product/AM62A7-Q1?keyMatch=&tisearch=search-everything&usecase=partmatches"
	$(Q)$(ECHO) "### ----------------------ending------------------------" 
