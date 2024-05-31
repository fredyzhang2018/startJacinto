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
ifeq ($(SJ_VER_SDK),09)
SJ_PATH_VISION_SDK_BUILD      ?= $(SJ_PATH_PSDKRA)/sdk_builder
else
SJ_PATH_VISION_SDK_BUILD      ?= $(SJ_PATH_PSDKRA)/vision_apps
endif
SJ_PATH_VISION_SDK_BUILD      ?= $(SJ_PATH_PSDKRA)/vision_apps
SJ_PATH_TUTORIAL_RUN          ?= $(SJ_PATH_PSDKRA)/tiovx/out/PC/x86_64/LINUX/
SJ_PATH_EDGEAI_TIDL_TOOLS     ?= $(SJ_PATH_SDK)/edgeai-tidl-tools/
SJ_PATH_PDK                   ?= $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep pdk`
SJ_PATH_UBOOT                 ?= $(SJ_PATH_PSDKLA)/board-support/`ls $(SJ_PATH_PSDKLA)/board-support | grep u-boot-`
SJ_PATH_KERNEL                ?= $(SJ_PATH_PSDKLA)/board-support/`ls $(SJ_PATH_PSDKLA)/board-support | grep linux-`
SJ_PATH_PYTORCH               ?= $(SJ_PATH_JACINTO)/python/startPytorch
export SJ_PATH_PDK
SJ_PDK_TOOLS_PATH             ?= /home/`whoami`/ti
SJ_UNIFLASH_TOOLS             ?= $(HOME)/ti/uniflash_8.4.0/
export SJ_UNIFLASH_TOOLS

#==============================================================================
# Tools and development
#==============================================================================
SJ_PATH_K3_BOOTSWITCH         ?= $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/
SJ_PATH_APPS                  ?= $(SJ_PATH_JACINTO)/sdks/apps/
#==============================================================================
# print env
#==============================================================================
print_env:
	$(Q)$(ECHO) "### -------------env setup------------------------------"
	$(Q)$(ECHO) "# $(YEL)SJ_PROJECT and Username:            $(RES)== $(PUR)$(SJ_PROJECT)  $(SJ_USERNAME)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_PSDKRA:                     $(RES)== $(PUR)$(SJ_PATH_PSDKRA)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_PSDKLA:                     $(RES)== $(PUR)$(SJ_PATH_PSDKLA)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_JACINTO:                    $(RES)== $(PUR)$(SJ_PATH_JACINTO)"
	$(Q)$(ECHO) "# $(YEL)SJ_WORK_PATH:                       $(RES)== $(PUR)$(SJ_WORK_PATH)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_SDK                         $(RES)== $(PUR)$(SJ_PATH_SDK)"	
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_SDK1                        $(RES)== $(PUR)$(SJ_PATH_SDK1)"	
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_TOOLS                       $(RES)== $(PUR)$(SJ_PATH_TOOLS)"	
	$(Q)$(ECHO) "# $(YEL)SJ_SOC_TYPE                         $(RES)== $(PUR)$(SJ_SOC_TYPE)"	
	$(Q)$(ECHO) "# $(YEL)SJ_GIT_SERVER                       $(RES)== $(PUR)$(SJ_GIT_SERVER)"	
	$(Q)$(ECHO) "# $(YEL)SJ_LOG_LEVEL                        $(RES)== $(PUR)$(SJ_LOG_LEVEL)"	
	$(Q)$(ECHO) "-------------Common Env------------------------------"
	$(Q)$(ECHO) "# $(YEL)SJ_BOOT SJ_BOOT1 and SJ_ROOTFS:     $(RES)== $(PUR)$(SJ_BOOT) $(SJ_BOOT1) $(SJ_ROOTFS)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_RESOURCE:                   $(RES)== $(PUR)$(SJ_PATH_RESOURCE)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_SCRIPTS:                    $(RES)== $(PUR)$(SJ_PATH_SCRIPTS)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_DOWNLOAD                    $(RES)== $(PUR)$(SJ_PATH_DOWNLOAD)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_TEST:                       $(RES)== $(PUR)$(SJ_PATH_TEST)"		
	$(Q)$(ECHO) "-------------debug use------------------------------"
	$(Q)$(ECHO) "# $(YEL)SJ_PROFILE:                         $(RES)== $(PUR)$(SJ_PROFILE)"
	$(Q)$(ECHO) "-------------PSDKLA PATH------------------------------"	
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_UBOOT:                      $(RES)== $(PUR)$(SJ_PATH_UBOOT)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_KERNEL:                     $(RES)== $(PUR)$(SJ_PATH_KERNEL)"
	$(Q)$(ECHO) "# $(YEL)SJ_PSDKLA_BRANCH:                   $(RES)== $(PUR)$(SJ_PSDKLA_BRANCH)"
	$(Q)$(ECHO) "# $(YEL)SJ_EVM_IP:                          $(RES)== $(PUR)$(SJ_EVM_IP)"
	$(Q)$(ECHO) "# $(YEL)SJ_SERVER_IP:                       $(RES)== $(PUR)$(SJ_SERVER_IP)"
	$(Q)$(ECHO) "# $(YEL)SJ_YOCTO_CONFIG_FILE:               $(RES)== $(PUR)$(SJ_YOCTO_CONFIG_FILE)"
	$(Q)$(ECHO) "-------------PSDKRA PATH------------------------------"	
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_VX_TEST_DATA:               $(RES)== $(PUR)$(SJ_PATH_VX_TEST_DATA)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_MCUSS:                      $(RES)== $(PUR)$(SJ_PATH_MCUSS)"
	$(Q)$(ECHO) "# $(YEL)SJ_PSDKRA_BRANCH:                   $(RES)== $(PUR)$(SJ_PSDKRA_BRANCH)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_PDK:                        $(RES)== $(PUR)$(SJ_PATH_PDK)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_IMAGING:                    $(RES)== $(PUR)$(SJ_PATH_IMAGING)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_VISION_SDK_BUILD:           $(RES)== $(PUR)$(SJ_PATH_VISION_SDK_BUILD)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_TUTORIAL_RUN:               $(RES)== $(PUR)$(SJ_PATH_TUTORIAL_RUN)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_EDGEAI_TIDL_TOOLS:          $(RES)== $(PUR)$(SJ_PATH_EDGEAI_TIDL_TOOLS)"
	$(Q)$(ECHO) "# $(YEL)SJ_PDK_TOOLS_PATH:                  $(RES)== $(PUR)$(SJ_PDK_TOOLS_PATH)"
	$(Q)$(ECHO) "-------------tools PATH------------------------------"	
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_K3_BOOTSWITCH:              $(RES)== $(PUR)$(SJ_PATH_K3_BOOTSWITCH)"
	$(Q)$(ECHO) "# $(YEL)SJ_UNIFLASH_TOOLS:                  $(RES)== $(PUR)$(SJ_UNIFLASH_TOOLS)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_PYTORCH:                    $(RES)== $(PUR)$(SJ_PATH_PYTORCH)"
	$(Q)$(ECHO) "# $(YEL)SJ_PATH_APPS:                       $(RES)== $(PUR)$(SJ_PATH_APPS)"
	$(Q)$(ECHO) "------------- User Guide   ------------------------------"	
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4VM"
	$(Q)$(ECHO) "# $(YEL)PSDKRA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-RTOS-J721E"
	$(Q)$(ECHO) "# $(YEL)PSDKLA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-LINUX-J721E"
else ifeq ($(SJ_SOC_TYPE),j721s2)
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4VE-Q1"
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4AL-Q1"
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4VL-Q1"
	$(Q)$(ECHO) "# $(YEL)PSDKRA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-RTOS-J721S2"
	$(Q)$(ECHO) "# $(YEL)PSDKLA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-LINUX-J721S2"
else ifeq ($(SJ_SOC_TYPE),j784S4)
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4VH"
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4AH"
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4VP"
	$(Q)$(ECHO) "# $(YEL)Soc:                       $(RES) ---LINK--- $(BLU)https://www.ti.com/product/TDA4AP"
	$(Q)$(ECHO) "# $(YEL)PSDKRA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-RTOS-J784S4"
	$(Q)$(ECHO) "# $(YEL)PSDKLA:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/tool/download/PROCESSOR-SDK-LINUX-J784S4"
endif
	$(Q)$(ECHO) "# $(YEL)AM62xx:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/product/AM625?keyMatch=&tisearch=search-everything&usecase=partmatches"
	$(Q)$(ECHO) "# $(YEL)AM62Ax:                    $(RES) ---LINK--- $(BLU)https://www.ti.com/product/AM62A7-Q1?keyMatch=&tisearch=search-everything&usecase=partmatches"
	$(Q)$(ECHO) "### ----------------------ending------------------------" 
