#
# SDK git management
#
# Edit this file to suit your specific build needs
#

sdk-git-status: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot status  !!!");
	$(Q)cd $(SJ_PATH_UBOOT)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot status --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel status  !!!");
	$(Q)cd $(SJ_PATH_KERNEL)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel stats --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel RTOS  !!!");
	$(Q)cd $(SJ_PATH_PSDKRA)/ && git status 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel RTOS --done !!!");


sdk-git-checkout-default: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: update the branch to default !!!");	
	$(Q)cd $(SJ_PATH_UBOOT)  && git checkout SDK_$(SJ_PSDKLA_BRANCH)_default
	$(Q)cd $(SJ_PATH_KERNEL) && git checkout SDK_$(SJ_PSDKLA_BRANCH)_default
	$(Q)cd $(SJ_PATH_PSDKRA) && git checkout SDK_$(SJ_PSDKRA_BRANCH)_default


sdk-git-create-default: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: update the branch to default !!!");	
	$(Q)cd $(SJ_PATH_UBOOT)  && git checkout -b SDK_$(SJ_PSDKLA_BRANCH)_default
	$(Q)cd $(SJ_PATH_KERNEL) && git checkout -b SDK_$(SJ_PSDKLA_BRANCH)_default
	$(Q)cd $(SJ_PATH_PSDKRA) && git checkout -b SDK_$(SJ_PSDKRA_BRANCH)_default


sdk-git-branch: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot branch  !!!");
	$(Q)cd $(SJ_PATH_UBOOT)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check uboot branch --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch  !!!");
	$(Q)cd $(SJ_PATH_KERNEL)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch --done !!!");
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch  !!!");
	$(Q)cd $(SJ_PATH_PSDKRA)/ && git branch 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: check kernel branch --done !!!");

sdk-git-command-uboot: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot command  CMD="command" !!!");
	$(Q)$(ECHO) "###################------uboot -----------#################################"	
	$(Q)cd $(SJ_PATH_UBOOT)/ && $(CMD)
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(ECHO) "$(SJ_PATH_UBOOT)"
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot command --done !!!");


sdk-git-command-kernel: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: kernel command CMD="command" !!!");
	$(Q)$(ECHO) "###################------kernel ----------#################################"	
	$(Q)cd $(SJ_PATH_KERNEL)/ && $(CMD)
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(ECHO) "$(SJ_PATH_KERNEL)"
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(call sj_echo_log, 0 , "sdk_git: kernel command --done !!!");

sdk-git-command-rtos: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: rtos command CMD="command" !!!");
	$(Q)$(ECHO) "#######################---------rtos------#################################"	
	$(Q)cd $(SJ_PATH_PSDKRA)/ && $(CMD)
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(ECHO) "$(SJ_PATH_PSDKRA)"
	$(Q)$(ECHO) "###########################################################################"
	$(Q)$(call sj_echo_log, 0 , "sdk_git: rtos command --done !!!");

sdk-git-command-all: 
	$(Q)$(call sj_echo_log, 0 , "sdk_git: uboot/kernel/rtos command CMD="command" !!!");
	$(Q)$(ECHO) "###################-------uboot -----------#################################"	
	$(Q)cd $(SJ_PATH_UBOOT)/ && $(CMD)
	$(Q)$(ECHO) "###################-------kernel ----------#################################"	
	$(Q)cd $(SJ_PATH_KERNEL)/ && $(CMD)
	$(Q)$(ECHO) "###################-------rtos   ----------#################################"
	$(Q)cd $(SJ_PATH_PSDKRA)/ && $(CMD)
	$(Q)$(ECHO) "############################################################################"
	$(Q)$(ECHO) "$(SJ_PATH_UBOOT)"
	$(Q)$(ECHO) "$(SJ_PATH_KERNEL)"
	$(Q)$(ECHO) "$(SJ_PATH_PSDKRA)"
	$(Q)$(ECHO) "############################################################################"
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
	$(Q)$(ECHO) "    sdk-git-command-all CMD="command"  "
	$(Q)$(ECHO) "    ---------------- ending  !!!-------------------------------------- 
