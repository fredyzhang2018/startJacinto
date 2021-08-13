#==============================================================================
# Makefile 
# Modified for projects Jacinto7 project
# By Fredy
# 2020-11-13
#==============================================================================
ifndef $(BUILD_FLAGS_MAK)
BUILD_FLAGS_MAK = 1
endif

# build verbose
PROJECT_VERSION                                    ?= 00_00_05
BUILD_FLAG_VERBOSE                                 ?=no
# build include
BUILD_INCLUDE_PSDKLA          ?=yes
BUILD_INCLUDE_PSDKLA_INSTALL  ?=yes
BUILD_INCLUDE_PSDKRA          ?=yes
BUILD_INCLUDE_PSDKRA_INSTALL  ?=yes
BUILD_INCLUDE_SD_INSTALL      ?=yes
BUILD_INCLUDE_CHECK_PATHS     ?=yes
BUILD_INCLUDE_MCUSS           ?=yes
BUILD_INCLUDE_K3_BOOTSWITCH   ?=yes
BUILD_INCLUDE_PDK             ?=yes
BUILD_INCLUDE_UBUNTU          ?=yes


#PSDKLA
YOCTO_CONFIG_FILE             ?=processor-sdk-linux-07_03_00.txt
PSDKLA_SDK_URL                ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin

#PSDKRA
PSDKRA_PG_NAME                ?=ti-processor-sdk-rtos-j721e-evm-07_03_00_07
PSDKRA_INSTALL_PACKAGES_LINK  ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/ti-processor-sdk-rtos-j721e-evm-07_03_00_07.tar.gz
PSDKRA_TI_DATA_DOWNLOAD_LINK  ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/psdk_rtos_ti_data_set_07_03_00.tar.gz
PSDKRA_TI_DATA_PTK_LINK		  ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
PSDKRA_ADD_ON_LINK			  ?=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v7.03.00/ti-processor-sdk-rtos-j721e-evm-07_03_00_07-addon-linux-x64-installer.run



print_config:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "### Below make variables control how the SDK is built. Modify as required."
	$(Q)$(ECHO) "#"
	$(Q)$(ECHO) "### Build flags in include build"
	$(Q)$(ECHO) "# PROJECT_VERSION                   = $(PROJECT_VERSION)"
	$(Q)$(ECHO) "# BUILD_FLAG_VERBOSE                = $(BUILD_FLAG_VERBOSE)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_PSDKLA              = $(BUILD_INCLUDE_PSDKLA)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_PSDKLA_INSTALL      = $(BUILD_INCLUDE_PSDKLA_INSTALL)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_PSDKRA              = $(BUILD_INCLUDE_PSDKRA)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_PSDKRA_INSTALL      = $(BUILD_INCLUDE_PSDKRA_INSTALL)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_SD_INSTALL          = $(BUILD_INCLUDE_SD_INSTALL)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_MCUSS          	 = $(BUILD_INCLUDE_MCUSS)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_K3_BOOTSWITCH       = $(BUILD_INCLUDE_K3_BOOTSWITCH)"
	$(Q)$(ECHO) "# BUILD_INCLUDE_PDK                 = $(BUILD_INCLUDE_PDK)"	
	$(Q)$(ECHO) "# BUILD_INCLUDE_PDK                 = $(BUILD_INCLUDE_UBUNTU)"	
	$(Q)$(ECHO) "#"
ifeq  ($(BUILD_INCLUDE_PSDKRA_INSTALL),yes)
	# PSDKRA INSTALL PATH 
	$(Q)$(ECHO) "	PSDKRA_PG_NAME               --> $(PSDKRA_PG_NAME)"
	$(Q)$(ECHO) "	PSDKRA_INSTALL_PACKAGES_LINK --> $(PSDKRA_INSTALL_PACKAGES_LINK)"
	$(Q)$(ECHO) "	PSDKRA_TI_DATA_DOWNLOAD_LINK --> $(PSDKRA_TI_DATA_DOWNLOAD_LINK)"
	$(Q)$(ECHO) "	PSDKLA_TI_DATA_PTK_LINK      --> $(PSDKRA_TI_DATA_PTK_LINK)"
	$(Q)$(ECHO) "	PSDKRA_ADD_ON_LINK           --> $(PSDKRA_ADD_ON_LINK)"
endif
ifeq  ($(BUILD_INCLUDE_PSDKLA_INSTALL),yes)
	# PSDKLA INSTALL PATH 
	$(Q)$(ECHO) "	YOCTO_CONFIG_FILE            --> $(YOCTO_CONFIG_FILE)"
	$(Q)$(ECHO) "	PSDKLA_SDK_URL               --> $(PSDKLA_SDK_URL)"
endif

	

#==============================================================================
# config make used tools
#==============================================================================
ifeq ($(BUILD_FLAG_VERBOSE),yes)
  Q = 
else
  Q = @
endif

MAKE := make
ECHO := echo
INSTALL := install
RM := rm 
CPU_NUM := $(shell nproc)
MV := mv
CP := cp -v 
CPR := cp -r 

print_variable:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "### Below variable is used for building the system."
	$(Q)$(ECHO) "#"
	$(Q)$(ECHO) "### Build variable in include build"
	$(Q)$(ECHO) "# Q = $(Q)"
	$(Q)$(ECHO) "# MAKE = $(MAKE)"
	$(Q)$(ECHO) "# ECHO = $(ECHO)"
	$(Q)$(ECHO) "# INSTALL = $(INSTALL)"
	$(Q)$(ECHO) "# RM = $(RM)"
	$(Q)$(ECHO) "# CPU_NUM = $(CPU_NUM)"
	$(Q)$(ECHO) "# MV = $(MV)"
	$(Q)$(ECHO) "# CP = $(CP)"
	$(Q)$(ECHO) "# CPR = $(CPR)"
	$(Q)$(ECHO) "### --------------------------------------------->>>>>>>>>>>>>>>>>"
	$(Q)$(ECHO)
	$(Q)$(ECHO)
	$(Q)$(ECHO)


#==============================================================================
# include settting
#==============================================================================


ifeq ($(BUILD_INCLUDE_PSDKLA),yes)
include makerules/makefile_psdkla.mak
endif

ifeq ($(BUILD_INCLUDE_PSDKRA),yes)
include makerules/makefile_psdkra.mak
endif

ifeq ($(BUILD_INCLUDE_SD_INSTALL),yes)
include makerules/makefile_sd_install.mak
endif

ifeq ($(BUILD_INCLUDE_CHECK_PATHS),yes)
include makerules/makefile_check_paths.mak
endif


ifeq ($(BUILD_INCLUDE_PSDKLA_INSTALL),yes)
include makerules/makefile_psdkla_install.mak 
endif


ifeq ($(BUILD_INCLUDE_PSDKRA_INSTALL),yes)
include makerules/makefile_psdkra_install.mak 
endif


ifeq ($(BUILD_INCLUDE_MCUSS),yes)
include makerules/makefile_mcuss.mak
endif

ifeq ($(BUILD_INCLUDE_K3_BOOTSWITCH),yes)
include makerules/makefile_k3_bootswitch.mak
endif

ifeq ($(BUILD_INCLUDE_PDK),yes)
include makerules/makefile_pdk.mak
endif

ifeq ($(BUILD_INCLUDE_UBUNTU),yes)
include makerules/makefile_ubuntu.mak
endif


