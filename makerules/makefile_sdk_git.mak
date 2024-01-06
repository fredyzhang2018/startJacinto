#
# SDK git management
#
# Edit this file to suit your specific build needs
#

sdk-git-status: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot status  !!!");
	cd $(SJ_PATH_UBOOT)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot status --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel status  !!!");
	cd $(SJ_PATH_KERNEL)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel stats --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel RTOS  !!!");
	cd $(SJ_PATH_PSDKRA)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel RTOS --done !!!");

sdk-git-branch: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot branch  !!!");
	cd $(SJ_PATH_UBOOT)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot branch --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch  !!!");
	cd $(SJ_PATH_KERNEL)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch  !!!");
	cd $(SJ_PATH_PSDKRA)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch --done !!!");

sdk-git-command-uboot: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot command  !!!");
	cd $(SJ_PATH_UBOOT)/ && $(COMMAND)
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot command --done !!!");


sdk-git-command-kernel: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: kernel command  !!!");
	cd $(SJ_PATH_KERNEL)/ && $(COMMAND)
	$(Q)$(call sj_echo_log, 0 , "sdk_git: kernel command --done !!!");

sdk-git-command-rtos: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: rtos command  !!!");
	cd $(SJ_PATH_PSDKRA)/ && $(COMMAND)
	$(Q)$(call sj_echo_log, 0 , "sdk_git: rtos command --done !!!");

sdk-git-command-all: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot/kernel/rtos command  !!!");
	cd $(SJ_PATH_UBOOT)/ && $(COMMAND)
	cd $(SJ_PATH_KERNEL)/ && $(COMMAND)
	cd $(SJ_PATH_PSDKRA)/ && $(COMMAND)
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot/kernel/rtos command --done !!!");

sdk-git-help:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "Available build targets are  :"
	$(Q)$(ECHO) "    ----------------Build --------------------------------------  "
	$(Q)$(ECHO) "    sdk_git_status    "
	$(Q)$(ECHO) "    sdk-git-branch   "
	$(Q)$(ECHO) "    sdk-git-command-uboot    "
	$(Q)$(ECHO) "    sdk-git-command-kernel   "
	$(Q)$(ECHO) "    sdk-git-command-rtos    "
	$(Q)$(ECHO) "    sdk-git-command-all   "
	$(Q)$(ECHO) "    ---------------- ending  !!!-------------------------------------- 