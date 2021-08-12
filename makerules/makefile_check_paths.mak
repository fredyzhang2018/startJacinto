#
# Utility makefile to check important paths needed for build
#
check_paths_sdk:
	if [ ! -d $(PSDKRA_PATH) ]; then echo 'ERROR: $(PSDKRA_PATH) not found !!!'; exit 1; fi
	if [ ! -d $(PSDKLA_PATH) ]; then echo 'ERROR: $(PSDKLA_PATH) not found !!!'; exit 1; fi
	@echo "# SDK paths OK !!!"

check_paths_sd:
	@if [ ! -d $(BOOT)   ]; then echo 'ERROR: $(BOOT)   not found !!!'; exit 1; fi
	@if [ ! -d $(ROOTFS) ]; then echo 'ERROR: $(ROOTFS) not found !!!'; exit 1; fi
	@echo "# sd paths OK !!!"

check_paths_sd_boot:
	@if [ ! -d $(BOOT)   ]; then echo 'ERROR: $(BOOT)   not found !!!'; exit 1; fi
	@echo "# $(BOOT) paths OK !!!"

check_paths_sd_boot1:
	@if [ ! -d $(BOOT1)   ]; then echo 'ERROR: $(BOOT1)   not found !!!'; exit 1; fi
	@echo "# $(BOOT1) paths OK !!!"

check_paths_sd_rootfs:
	@if [ ! -d $(ROOTFS) ]; then echo 'ERROR: $(ROOTFS) not found !!!'; exit 1; fi
	@echo "# $(ROOTFS) rootfs OK !!!"

check_paths_downloads:
	@if [ ! -d $(DOWNLOADS_PATH) ]; then echo 'ERROR: $(DOWNLOADS_PATH) not found !!!'; exit 1; fi
	@echo "# $(DOWNLOADS_PATH) is exist !!!"

check_paths_PSDKLA:
	$(Q)if [ ! -d $(PSDKLA_PATH) ]; then echo 'ERROR: $(PSDKLA_PATH) not found !!!'; exit 1; fi
	@echo "# $(PSDKLA_PATH) is exist !!!"

check_paths_PSDKRA:
	@if [ ! -d $(PSDKRA_PATH) ]; then echo 'ERROR: $(PSDKRA_PATH) not found !!!'; exit 1; fi
	@echo "# $(PSDKRA_PATH) is exist !!!"
	
check_paths_PSDKLA_K3_BOOTSWITCH:
	$(Q)if [ ! -d $(K3_BOOTSWITCH_PATH) ]; then echo 'ERROR: $(K3_BOOTSWITCH_PATH) not found !!!'; exit 1; fi
	@echo "# $(K3_BOOTSWITCH_PATH) is exist !!!"
