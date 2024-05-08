#
# Utility makefile to check important paths needed for build
#
define sj_check_path
	@if [ ! -d $(1) ]; then echo -e '${RED}$(BOLD)ERROR$(RES): ${PUR}$(ITAL)$(1)$(RES) ${RED}$(BOLD)not found !!!$(RES)'; exit 1; fi
	@echo -e "# ${PUR}$(ITAL)$(1)$(RES) path ${GRE}$(BOLD)OK !!!$(RES)"
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
	$(Q)$(call sj_echo_log, info , "# check_paths_Help....."); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "check_paths_sdk", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_sd", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_sd_boot", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_sd_boot1", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_sd_rootfs", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_downloads", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_PSDKLA", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_PSDKRA", " "); 
	$(Q)$(call sj_echo_log, help , "check_paths_PSDKLA_K3_BOOTSWITCH", " "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "# check_paths_Help..... done!"); 


