#==============================================================================
# Makefile 
# Modified for projects Jacinto7 project
# By Fredy
# 2020-11-13
#==============================================================================
ifndef $(SJ_BUILD_FLAGS_MAK)
SJ_BUILD_FLAGS_MAK = 1
endif

# build verbose
SJ_PROJECT_VERSION                                    ?= 20_02_00
SJ_BUILD_FLAG_VERBOSE                                 ?=no
# build include
SJ_BUILD_INCLUDE_PSDKLA          ?=yes
SJ_BUILD_INCLUDE_PSDKLA_INSTALL  ?=yes
SJ_BUILD_INCLUDE_PSDKRA          ?=yes
SJ_BUILD_INCLUDE_PSDKRA_INSTALL  ?=yes
SJ_BUILD_INCLUDE_SD_INSTALL      ?=yes
SJ_BUILD_INCLUDE_CHECK_PATHS     ?=yes
SJ_BUILD_INCLUDE_MCUSS           ?=yes
SJ_BUILD_INCLUDE_K3_BOOTSWITCH   ?=yes
SJ_BUILD_INCLUDE_PDK             ?=yes
SJ_BUILD_INCLUDE_UBUNTU          ?=yes
SJ_BUILD_INCLUDE_GATEWAYDEMO     ?=yes

#PSDKLA
SJ_YOCTO_CONFIG_FILE             ?=processor-sdk-linux-07_03_00.txt
SJ_PSDKLA_SDK_URL                ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin

#PSDKRA
SJ_PSDKRA_PG_NAME                ?=ti-processor-sdk-rtos-j721e-evm-07_03_00_07
SJ_PSDKRA_INSTALL_PACKAGES_LINK  ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/ti-processor-sdk-rtos-j721e-evm-07_03_00_07.tar.gz
SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK  ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_03_00_07/exports/psdk_rtos_ti_data_set_07_03_00.tar.gz
SJ_PSDKRA_TI_DATA_PTK_LINK		 ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/07_01_00_11/exports/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
SJ_PSDKRA_ADD_ON_LINK			 ?=https://software-dl.ti.com/secure/software/adas/PSDK-RTOS-AUTO/PSDK_RTOS_v7.03.00/ti-processor-sdk-rtos-j721e-evm-07_03_00_07-addon-linux-x64-installer.run

ifeq ($(SJ_PROJECT),Workarea_08_00_00_08)
SJ_PSDKRA_BRANCH    ?= PSDKRA_08_00_00_12
SJ_PSDKLA_BRANCH    ?= 08_00_00_08
endif

print_config:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "### Below make variables control how the SDK is built. Modify as required."
	$(Q)$(ECHO) "#"
	$(Q)$(ECHO) "### Build flags in include build"
	$(Q)$(ECHO) "# SJ_PROJECT_VERSION                   = $(SJ_PROJECT_VERSION)"
	$(Q)$(ECHO) "# SJ_BUILD_FLAG_VERBOSE                = $(SJ_BUILD_FLAG_VERBOSE)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PSDKLA              = $(SJ_BUILD_INCLUDE_PSDKLA)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PSDKLA_INSTALL      = $(SJ_BUILD_INCLUDE_PSDKLA_INSTALL)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PSDKRA              = $(SJ_BUILD_INCLUDE_PSDKRA)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PSDKRA_INSTALL      = $(SJ_BUILD_INCLUDE_PSDKRA_INSTALL)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_SD_INSTALL          = $(SJ_BUILD_INCLUDE_SD_INSTALL)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_MCUSS               = $(SJ_BUILD_INCLUDE_MCUSS)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_K3_BOOTSWITCH       = $(SJ_BUILD_INCLUDE_K3_BOOTSWITCH)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PDK                 = $(SJ_BUILD_INCLUDE_PDK)"	
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_UBUNTU              = $(SJ_BUILD_INCLUDE_UBUNTU)"
	$(Q)$(ECHO) "#"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_GATEWAYDEMO         = $(SJ_BUILD_INCLUDE_GATEWAYDEMO)"
ifeq  ($(SJ_BUILD_INCLUDE_PSDKRA_INSTALL),yes)
	# PSDKRA INSTALL PATH 
	$(Q)$(ECHO) "	SJ_PSDKRA_PG_NAME               --> $(SJ_PSDKRA_PG_NAME)"
	$(Q)$(ECHO) "	SJ_PSDKRA_INSTALL_PACKAGES_LINK --> $(SJ_PSDKRA_INSTALL_PACKAGES_LINK)"
	$(Q)$(ECHO) "	SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK --> $(SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK)"
	$(Q)$(ECHO) "	SJ_PSDKLA_TI_DATA_PTK_LINK      --> $(SJ_PSDKRA_TI_DATA_PTK_LINK)"
	$(Q)$(ECHO) "	SJ_PSDKRA_ADD_ON_LINK           --> $(SJ_PSDKRA_ADD_ON_LINK)"
	$(Q)$(ECHO) "	SJ_PSDKRA_BRANCH                --> $(SJ_PSDKRA_BRANCH)"
endif
ifeq  ($(SJ_BUILD_INCLUDE_PSDKLA_INSTALL),yes)
	# PSDKLA INSTALL PATH 
	$(Q)$(ECHO) "	SJ_YOCTO_CONFIG_FILE            --> $(SJ_YOCTO_CONFIG_FILE)"
	$(Q)$(ECHO) "	SJ_PSDKLA_SDK_URL               --> $(SJ_PSDKLA_SDK_URL)"
	$(Q)$(ECHO) "	SJ_PSDKLA_BRANCH                --> $(SJ_PSDKLA_BRANCH)"
endif

#==============================================================================
# config make used tools
#==============================================================================
ifeq ($(SJ_BUILD_FLAG_VERBOSE),yes)
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


#==============================================================================
# include settting
#==============================================================================


ifeq ($(SJ_BUILD_INCLUDE_PSDKLA),yes)
include makerules/makefile_psdkla.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_PSDKRA),yes)
include makerules/makefile_psdkra.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_SD_INSTALL),yes)
include makerules/makefile_sd_install.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_CHECK_PATHS),yes)
include makerules/makefile_check_paths.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_PSDKLA_INSTALL),yes)
include makerules/makefile_psdkla_install.mak 
endif


ifeq ($(SJ_BUILD_INCLUDE_PSDKRA_INSTALL),yes)
include makerules/makefile_psdkra_install.mak 
endif


ifeq ($(SJ_BUILD_INCLUDE_MCUSS),yes)
include makerules/makefile_mcuss.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_K3_BOOTSWITCH),yes)
include makerules/makefile_k3_bootswitch.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_PDK),yes)
include makerules/makefile_pdk.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_UBUNTU),yes)
include makerules/makefile_ubuntu.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_MANIFEST),yes)
include makerules/makefile_manifest.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_GATEWAYDEMO),yes)
include makerules/makefile_gateway_demo.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_CIIE_DEMO),yes)
include makerules/makefile_ciie_demo.mak
endif
