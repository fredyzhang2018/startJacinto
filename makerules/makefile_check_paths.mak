#
# Utility makefile to check important paths needed for build
#
check_paths_sdk:
	if [ ! -d $(SJ_PATH_PSDKRA) ]; then echo 'ERROR: $(SJ_PATH_PSDKRA) not found !!!'; exit 1; fi
	if [ ! -d $(SJ_PATH_PSDKLA) ]; then echo 'ERROR: $(SJ_PATH_PSDKLA) not found !!!'; exit 1; fi
	@echo "# SDK paths OK !!!"

check_paths_sd:
	@if [ ! -d $(SJ_BOOT)   ]; then echo 'ERROR: $(SJ_BOOT)   not found !!!'; exit 1; fi
	@if [ ! -d $(SJ_ROOTFS) ]; then echo 'ERROR: $(SJ_ROOTFS) not found !!!'; exit 1; fi
	@echo "# sd paths OK !!!"

check_paths_sd_boot:
	@if [ ! -d $(SJ_BOOT)   ]; then echo 'ERROR: $(SJ_BOOT)   not found !!!'; exit 1; fi
	@echo "# $(SJ_BOOT) paths OK !!!"

check_paths_sd_boot1:
	@if [ ! -d $(SJ_BOOT1)   ]; then echo 'ERROR: $(SJ_BOOT1)   not found !!!'; exit 1; fi
	@echo "# $(SJ_BOOT1) paths OK !!!"

check_paths_sd_rootfs:
	@if [ ! -d $(SJ_ROOTFS) ]; then echo 'ERROR: $(SJ_ROOTFS) not found !!!'; exit 1; fi
	@echo "# $(SJ_ROOTFS) rootfs OK !!!"

check_paths_downloads:
	@if [ ! -d $(SJ_PATH_DOWNLOAD) ]; then echo 'ERROR: $(SJ_PATH_DOWNLOAD) not found !!!'; exit 1; fi
	@echo "# $(SJ_PATH_DOWNLOAD) is exist !!!"

check_paths_PSDKLA:
	$(Q)if [ ! -d $(SJ_PATH_PSDKLA) ]; then echo 'ERROR: $(SJ_PATH_PSDKLA) not found !!!'; exit 1; fi
	@echo "# $(SJ_PATH_PSDKLA) is exist !!!"

check_paths_PSDKRA:
	@if [ ! -d $(SJ_PATH_PSDKRA) ]; then echo 'ERROR: $(SJ_PATH_PSDKRA) not found !!!'; exit 1; fi
	@echo "# $(SJ_PATH_PSDKRA) is exist !!!"
	
check_paths_PSDKLA_K3_BOOTSWITCH:
	$(Q)if [ ! -d $(SJ_PATH_K3_BOOTSWITCH) ]; then echo 'ERROR: $(SJ_PATH_K3_BOOTSWITCH) not found !!!'; echo "please run : ubuntu-install-jacinto7-host-tools";  exit 1; fi
	$(Q)$(ECHO) "# $(SJ_PATH_K3_BOOTSWITCH) is exist !!!"
