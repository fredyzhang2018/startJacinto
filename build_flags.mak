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
SJ_PROJECT_VERSION                                    ?= 30_00_00
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
SJ_BUILD_INCLUDE_MANIFEST        ?=no
SJ_BUILD_INCLUDE_GATEWAYDEMO     ?=yes
SJ_BUILD_INCLUDE_DEMO            ?=no
SJ_BUILD_INCLUDE_NFS             ?=yes
SJ_BUILD_INCLUDE_TIDL            ?=yes
SJ_BUILD_INCLUDE_PC_RUN_DEMO     ?=yes
SJ_BUILD_INCLUDE_SDK_GIT         ?=yes

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
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_MANIFEST            = $(SJ_BUILD_INCLUDE_MANIFEST)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_GATEWAYDEMO         = $(SJ_BUILD_INCLUDE_GATEWAYDEMO)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_DEMO                = $(SJ_BUILD_INCLUDE_DEMO)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_NFS                 = $(SJ_BUILD_INCLUDE_NFS)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_TIDL                = $(SJ_BUILD_INCLUDE_TIDL)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_PC_RUN_DEMO         = $(SJ_BUILD_INCLUDE_PC_RUN_DEMO)"
	$(Q)$(ECHO) "# SJ_BUILD_INCLUDE_SDK_GIT             = $(SJ_BUILD_INCLUDE_SDK_GIT)"
ifeq  ($(SJ_BUILD_INCLUDE_PSDKRA_INSTALL),yes)
	$(Q)$(ECHO) "# SJ_PSDKRA_BRANCH                --> $(SJ_PSDKRA_BRANCH)"
endif
ifeq  ($(SJ_BUILD_INCLUDE_PSDKLA_INSTALL),yes)
	$(Q)$(ECHO) "# SJ_PSDKLA_BRANCH                --> $(SJ_PSDKLA_BRANCH)"
endif
	$(Q)$(ECHO) "# SJ_VER_SDK                      --> $(SJ_VER_SDK)"
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

ifeq ($(SJ_BUILD_INCLUDE_DEMO),yes)
include makerules/makefile_demo.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_NFS),yes)
include makerules/makefile_nfs.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_TIDL),yes)
include makerules/makefile_tidl.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_PC_RUN_DEMO),yes)
include makerules/makefile_pc_run_demo.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_PC_RUN_DEMO),yes)
include makerules/makefile_sdk_git.mak
endif