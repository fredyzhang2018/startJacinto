#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#

MAKE_EXTRA_OPTIONS=-j4

ifeq ($(PROFILE), $(filter $(PROFILE),release all))
PDK_BUILD_PROFILE_LIST_ALL+=release
endif
ifeq ($(PROFILE), $(filter $(PROFILE),debug all))
PDK_BUILD_PROFILE_LIST_ALL+=debug
endif

# vision_apps does not use A72 SysBIOS
#ifeq ($(BUILD_CPU_MPU1),yes)
#PDK_CORE_LIST_ALL+=mpu1_0
#endif
ifeq ($(BUILD_CPU_MCU1_0),yes)
PDK_CORE_LIST_ALL+=mcu1_0
endif
ifeq ($(BUILD_CPU_MCU1_1),yes)
PDK_CORE_LIST_ALL+=mcu1_1
endif
ifeq ($(BUILD_CPU_MCU2_0),yes)
PDK_CORE_LIST_ALL+=mcu2_0
endif
ifeq ($(BUILD_CPU_MCU2_1),yes)
PDK_CORE_LIST_ALL+=mcu2_1
endif
ifeq ($(BUILD_CPU_MCU3_0),yes)
PDK_CORE_LIST_ALL+=mcu3_0
endif
ifeq ($(BUILD_CPU_MCU3_1),yes)
PDK_CORE_LIST_ALL+=mcu3_1
endif
ifeq ($(BUILD_CPU_C6x_1),yes)
PDK_CORE_LIST_ALL+=c66xdsp_1
endif
ifeq ($(BUILD_CPU_C6x_2),yes)
PDK_CORE_LIST_ALL+=c66xdsp_2
endif
ifeq ($(BUILD_CPU_C7x_1),yes)
PDK_CORE_LIST_ALL+=c7x_1
endif

pdk_build:
	make -C $(PDK_PATH)/packages/ti/build BOARD=$(BUILD_PDK_BOARD) custom_target BUILD_PROFILE_LIST_ALL="$(PDK_BUILD_PROFILE_LIST_ALL)" CORE_LIST_ALL="$(PDK_CORE_LIST_ALL)" BUILD_TARGET_LIST_ALL="$(PDK_BUILD_TARGET_LIST_ALL)" -s $(MAKE_EXTRA_OPTIONS)

pdk: pdk_emu
ifeq ($(BUILD_TARGET_MODE),yes)
	make pdk_build -s PDK_BUILD_TARGET_LIST_ALL="pdk_libs"
endif

pdk_emu:
ifeq ($(BUILD_EMULATION_MODE),yes)
	make -C $(PDK_PATH)/packages/ti/build csl osal_nonos sciclient udma dmautils SOC=j721e BOARD=j721e_hostemu CORE=c7x-hostemu -s -j BUILD_PROFILE=release
	make -C $(PDK_PATH)/packages/ti/build csl osal_nonos sciclient udma dmautils SOC=j721e BOARD=j721e_hostemu CORE=c7x-hostemu -s -j BUILD_PROFILE=debug
endif

pdk_clean:
	make pdk_build PDK_BUILD_TARGET_LIST_ALL="pdk_libs_clean"

pdk_emu_clean:
ifeq ($(BUILD_EMULATION_MODE),yes)
	make -C $(PDK_PATH)/packages/ti/build csl_clean osal_nonos_clean sciclient_clean udma_clean dmautils_clean SOC=j721e BOARD=j721e_hostemu CORE=c7x-hostemu -s -j BUILD_PROFILE=release
	make -C $(PDK_PATH)/packages/ti/build csl_clean osal_nonos_clean sciclient_clean udma_clean dmautils_clean SOC=j721e BOARD=j721e_hostemu CORE=c7x-hostemu -s -j BUILD_PROFILE=debug
endif

pdk_scrub:
	make -C $(PDK_PATH)/packages/ti/build allclean
	rm -rf $(PDK_PATH)/packages/ti/binary
	rm -rf $(PDK_PATH)/packages/ti/boot/sbl/binary

.PHONY: pdk pdk_clean pdk_build
