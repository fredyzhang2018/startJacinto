#
# Utility makefile to check important paths needed for build
#
define sj_check_path
	@if [ ! -d $(1) ]; then echo 'ERROR: $(1) not found !!!'; exit 1; fi
	@echo "# $(1) path OK !!!"
endef

check_paths_sdk:
	$(call sj_check_path,$(SJ_PATH_PSDKLA));
	$(call sj_check_path,$(SJ_PATH_PSDKRA));

check_paths_sd:
	$(call sj_check_path,$(SJ_BOOT));
	$(call sj_check_path,$(SJ_ROOTFS));

check_paths_sd_boot:
	$(call sj_check_path,$(SJ_BOOT));

check_paths_sd_boot1:
	$(call sj_check_path,$(SJ_BOOT1));

check_paths_sd_rootfs:
	$(call sj_check_path,$(SJ_ROOTFS));

check_paths_downloads:
	$(call sj_check_path,$(SJ_PATH_DOWNLOAD));

check_paths_PSDKLA:
	$(call sj_check_path,$(SJ_PATH_PSDKLA));

check_paths_PSDKRA:
	$(call sj_check_path,$(SJ_PATH_PSDKRA));
	
check_paths_PSDKLA_K3_BOOTSWITCH:
	$(call sj_check_path,$(SJ_PATH_K3_BOOTSWITCH));

check_paths_EDGEAI_TIDL_TOOLS:
	$(call sj_check_path,$(SJ_PATH_EDGEAI_TIDL_TOOLS));


check_paths_help:
	# check_paths_sdk
	# check_paths_sd
	# check_paths_sd_boot
	# check_paths_sd_boot1
	# check_paths_sd_rootfs
	# check_paths_downloads
	# check_paths_PSDKLA
	# check_paths_PSDKRA
	# check_paths_PSDKLA_K3_BOOTSWITCH



