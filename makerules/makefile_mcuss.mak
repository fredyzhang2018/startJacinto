##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################

## Can Profiling Application
mcuss_can_profile_app:
	$(Q)echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(MCUSS_PATH)/build can_profile_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_can_profile_app --done Binary-$(PSDKRA_PATH)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
	$(Q)echo "Binary debug with CCS---->>>> $(PSDKRA_PATH)/mcusw/binary/mcuss_can_profile_app/bin/j721e_evm!!!";
mcuss_can_profile_app_clean:
	$(Q)echo "start build the mcuss_can_profile_app";
	$(MAKE) -C $(MCUSS_PATH)/build can_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_can_profile_app --done !!!";	 

## IPC Profiling Application
mcuss_cdd_ipc_profile_app:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app";
	$(MAKE) -C $(MCUSS_PATH)/build can_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app --done !!!";	 
	$(Q)echo "Binary ---->>>> $(PSDKRA_PATH)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_cdd_ipc_profile_app_clean:
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean";
	$(MAKE) -C $(MCUSS_PATH)/build cdd_ipc_profile_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_cdd_ipc_profile_app_clean --done !!!";	 

## ipc_remote_app
mcuss_ipc_remote_app:
	$(Q)echo "start build the mcuss_ipc_remote_app";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_remote_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=debug CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_ipc_remote_app --done !!!";	 
	$(Q)echo "Binary ---->>>> $(PSDKRA_PATH)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_ipc_remote_app_clean:
	$(Q)echo "start build the mcuss_ipc_remote_app_clean";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_remote_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcuss_ipc_remote_app_clean --done !!!";	

## SPI IPC/Communication Application
mcuss_ipc_spi_master_demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_spi_master_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(PSDKRA_PATH)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_ipc_spi_master_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_spi_master_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
mcuss_ipc_spi_slave_demo_app:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_spi_slave_demo_app BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	
	$(Q)echo "Binary ---->>>> $(PSDKRA_PATH)/mcusw/binary/(driver name)_app/bin/j721e_evm!!!";
mcuss_ipc_spi_slave_demo_app_clean:
	$(Q)echo "start build the mcu demo";
	$(MAKE) -C $(MCUSS_PATH)/build ipc_spi_slave_demo_app_clean BOARD=j721e_evm SOC=j721e BUILD_PROFILE=release CORE=mcu1_0 BUILD_OS_TYPE=tirtos -s -j$(CPU_NUM)
	$(Q)echo "start build the mcu demo --done !!!";	

## Print CCS path 
mcuss_ccs_script_path:
	$(Q)echo "SDK0703: loadJSFile(\"$(PSDKRA_PATH)/pdk_jacinto_07_03_00_29/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\") "
