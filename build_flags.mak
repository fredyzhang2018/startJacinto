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
SJ_BUILD_INCLUDE_CHECK_PATHS     ?=yes
SJ_BUILD_INCLUDE_MCUSS           ?=yes
SJ_BUILD_INCLUDE_K3_BOOTSWITCH   ?=yes
SJ_BUILD_INCLUDE_PDK             ?=yes
SJ_BUILD_INCLUDE_UBUNTU          ?=yes
SJ_BUILD_INCLUDE_MANIFEST        ?=no
SJ_BUILD_INCLUDE_GATEWAYDEMO     ?=yes
SJ_BUILD_INCLUDE_NFS             ?=yes
SJ_BUILD_INCLUDE_TIDL            ?=yes
SJ_BUILD_INCLUDE_APPS_DEMO       ?=yes
SJ_BUILD_INCLUDE_SDK_GIT         ?=yes
SJ_BUILD_INCLUDE_ADB             ?=yes
print_config:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "### Below make variables control how the SDK is built. Modify as required."
	$(Q)$(ECHO) "#"
	$(Q)$(ECHO) "### Build flags in include build"
	$(Q)$(ECHO) "# $(YEL)SJ_PROJECT_VERSION                   $(RES)== $(PUR)$(SJ_PROJECT_VERSION)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_FLAG_VERBOSE                $(RES)== $(PUR)$(SJ_BUILD_FLAG_VERBOSE)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_PSDKLA              $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_PSDKLA)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_PSDKLA_INSTALL      $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_PSDKLA_INSTALL)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_PSDKRA              $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_PSDKRA)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_PSDKRA_INSTALL      $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_PSDKRA_INSTALL)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_SD_INSTALL          $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_SD_INSTALL)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_MCUSS               $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_MCUSS)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_K3_BOOTSWITCH       $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_K3_BOOTSWITCH)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_PDK                 $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_PDK)"	
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_UBUNTU              $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_UBUNTU)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_MANIFEST            $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_MANIFEST)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_GATEWAYDEMO         $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_GATEWAYDEMO)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_NFS                 $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_NFS)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_TIDL                $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_TIDL)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_APPS_DEMO           $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_APPS_DEMO)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_SDK_GIT             $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_SDK_GIT)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_ADB                 $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_ADB)"
	$(Q)$(ECHO) "# $(YEL)SJ_BUILD_INCLUDE_AIMODEL             $(RES)== $(PUR)$(SJ_BUILD_INCLUDE_AIMODEL)"
ifeq  ($(SJ_BUILD_INCLUDE_PSDKRA_INSTALL),yes)
	$(Q)$(ECHO) "# $(YEL)SJ_PSDKRA_BRANCH                     $(RES)== $(PUR)$(SJ_PSDKRA_BRANCH)"
endif
ifeq  ($(SJ_BUILD_INCLUDE_PSDKLA_INSTALL),yes)
	$(Q)$(ECHO) "# $(YEL)SJ_PSDKLA_BRANCH                     $(RES)== $(PUR)$(SJ_PSDKLA_BRANCH)"
endif
	$(Q)$(ECHO) "# $(YEL)SJ_VER_SDK                           $(RES)== $(PUR)$(SJ_VER_SDK)"
#==============================================================================
# config make used tools
#==============================================================================
ifeq ($(SJ_BUILD_FLAG_VERBOSE),yes)
  Q = 
else
  Q = @
endif

MAKE := make
ECHO := echo -e
INSTALL := install
RM := rm 
CPU_NUM := $(shell nproc)
MV := mv
CP := cp -v 
CPR := cp -r 

print_variable:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "$(GRE)### Below variable is used for building the system."
	$(Q)$(ECHO) "$(GRE)#"
	$(Q)$(ECHO) "$(GRE)### Build variable in include build"
	$(Q)$(ECHO) "# $(YEL)Q        $(RES)== $(PUR)$(Q)"
	$(Q)$(ECHO) "# $(YEL)MAKE     $(RES)== $(PUR)$(MAKE)"
	$(Q)$(ECHO) "# $(YEL)ECHO     $(RES)== $(PUR)$(ECHO)"
	$(Q)$(ECHO) "# $(YEL)INSTALL  $(RES)== $(PUR)$(INSTALL)"
	$(Q)$(ECHO) "# $(YEL)RM       $(RES)== $(PUR)$(RM)"
	$(Q)$(ECHO) "# $(YEL)CPU_NUM  $(RES)== $(PUR)$(CPU_NUM)"
	$(Q)$(ECHO) "# $(YEL)MV       $(RES)== $(PUR)$(MV)"
	$(Q)$(ECHO) "# $(YEL)CP       $(RES)== $(PUR)$(CP)"
	$(Q)$(ECHO) "# $(YEL)CPR      $(RES)== $(PUR)$(CPR)"
	$(Q)$(ECHO) "$(GRE)### --------------------------------------------->>>>>>>>>>>>>>>>>"


#==============================================================================
# include settting
#==============================================================================


ifeq ($(SJ_BUILD_INCLUDE_PSDKLA),yes)
include makerules/makefile_psdkla.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_PSDKRA),yes)
include makerules/makefile_psdkra.mak
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

ifeq ($(SJ_BUILD_INCLUDE_NFS),yes)
include makerules/makefile_nfs.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_TIDL),yes)
include makerules/makefile_tidl.mak
endif


ifeq ($(SJ_BUILD_INCLUDE_APPS_DEMO),yes)
include makerules/makefile_apps_demo.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_SDK_GIT),yes)
include makerules/makefile_sdk_git.mak
endif

ifeq ($(SJ_BUILD_INCLUDE_ADB),yes)
include makerules/makefile_adb.mak
endif