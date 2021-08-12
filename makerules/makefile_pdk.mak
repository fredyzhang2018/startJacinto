#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#

BOARD = j721e_evm
# mpu1_0, mcu1_0, mcu1_1, mcu2_0, mcu2_1, mcu3_0, mcu3_1, c66xdsp_1, c66xdsp_2, c7
CORE = mcu1_0
# csl osal_nonos sciclient udma dmautils pdk_examples csl_uart_test_app csl_uart_test_app csl_i2c_led_blink_app
MODULES =  pdk_examples 

BUILD_PROFILE=debug


pdk-build: check_paths_PSDKRA pdk-build-configure
	$(Q)echo "board : $(BOARD)  modules: $(MODULES)  cores = $(CORE)  "
	$(MAKE) -C $(PDK_PATH)/packages/ti/build $(MODULES) SOC=j721e BOARD=$(BOARD) CORE=$(CORE) -s BUILD_PROFILE=$(BUILD_PROFILE) -j$(CPU_NUM)
	$(Q)echo "build board : $(BOARD)  modules: $(MODULES)  cores = $(CORE) done!"

pdk-build-configure: check_paths_PSDKRA
	$(Q)echo "build configuration: $(BOARD)  modules: $(MODULES)  cores = $(CORE)  BUILD_PROFILE=$(BUILD_PROFILE) "


pdk-clean:
	$(MAKE) pdk_build PDK_BUILD_TARGET_LIST_ALL="pdk_libs_clean"

pdk-scrub: check_paths_PSDKRA
	$(MAKE) -C $(PDK_PATH)/packages/ti/build allclean
	rm -rf $(PDK_PATH)/packages/ti/binary
	rm -rf $(PDK_PATH)/packages/ti/boot/sbl/binary
	$(MAKE) pdk-build-configure
	


pdk-help:
	$(MAKE) -C $(PDK_PATH)/packages/ti/build help BOARD=$(BOARD)
