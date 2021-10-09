#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#

SJ_PDK_BOARD = j721e_evm
# mpu1_0, mcu1_0, mcu1_1, mcu2_0, mcu2_1, mcu3_0, mcu3_1, c66xdsp_1, c66xdsp_2, c7
SJ_PDK_CORE = mcu1_0
# csl osal_nonos sciclient udma dmautils pdk_examples csl_uart_test_app csl_uart_test_app csl_i2c_led_blink_app
SJ_PDK_MODULES =  pdk_examples 

SJ_PDK_BUILD_PROFILE=debug


pdk-build: check_paths_PSDKRA pdk-build-configure
	$(Q)echo "board : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE)  "
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build $(SJ_PDK_MODULES) SOC=j721e BOARD=$(SJ_PDK_BOARD) CORE=$(SJ_PDK_CORE) -s BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) -j$(CPU_NUM)
	$(Q)echo "build SJ_PDK_BOARD : $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE) done!"

pdk-build-configure: check_paths_PSDKRA
	$(Q)echo "build configuration: $(SJ_PDK_BOARD)  modules: $(SJ_PDK_MODULES)  cores = $(SJ_PDK_CORE)  BUILD_PROFILE=$(SJ_PDK_BUILD_PROFILE) "


pdk-clean:
	$(MAKE) pdk_build PDK_BUILD_TARGET_LIST_ALL="pdk_libs_clean"

pdk-scrub: check_paths_PSDKRA
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build allclean
	rm -rf $(SJ_PATH_PDK)/packages/ti/binary
	rm -rf $(SJ_PATH_PDK)/packages/ti/boot/sbl/binary
	$(MAKE) pdk-build-configure
	


pdk-help:
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build help BOARD=$(SJ_PDK_BOARD)
	$(Q)$(ECHO) " Variable Setting : "
	$(Q)$(ECHO) "#   SJ_PDK_BOARD = $(SJ_PDK_BOARD)"
	$(Q)$(ECHO) "#   SJ_PDK_CORE  = $(SJ_PDK_CORE)"
	$(Q)$(ECHO) "#   SJ_PDK_MODULES = $(SJ_PDK_MODULES)"
	$(Q)$(ECHO) "#   SJ_PDK_BUILD_PROFILE = $(SJ_PDK_BUILD_PROFILE)"
