#
# SDK git management
#
# Edit this file to suit your specific build needs
#

sdk_git_status: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: check uboot status  !!!");
	cd $(SJ_PATH_UBOOT)/ && git status 
	$(Q)$(call sj_echo_log, info , "sdk_git: check uboot status --done !!!");
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel status  !!!");
	cd $(SJ_PATH_KERNEL)/ && git status 
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel stats --done !!!");
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel RTOS  !!!");
	cd $(SJ_PATH_PSDKRA)/ && git status 
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel RTOS --done !!!");

sdk_git_branch: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: check uboot branch  !!!");
	cd $(SJ_PATH_UBOOT)/ && git branch 
	$(Q)$(call sj_echo_log, info , "sdk_git: check uboot branch --done !!!");
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel branch  !!!");
	cd $(SJ_PATH_KERNEL)/ && git branch 
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel branch --done !!!");
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel branch  !!!");
	cd $(SJ_PATH_PSDKRA)/ && git branch 
	$(Q)$(call sj_echo_log, info , "sdk_git: check kernel branch --done !!!");

sdk_git_command_uboot: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: uboot command  !!!");
	$(Q)$(call sj_echo_log, warning , "using CMD=\"\"  !!!");
	cd $(SJ_PATH_UBOOT)/ && $(CMD)
	$(Q)$(call sj_echo_log, info , "sdk_git: uboot command --done !!!");


sdk_git_command_kernel: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: kernel command  !!!");
	$(Q)$(call sj_echo_log, warning , "using CMD=\"\"  !!!");
	cd $(SJ_PATH_KERNEL)/ && $(CMD)
	$(Q)$(call sj_echo_log, info , "sdk_git: kernel command --done !!!");

sdk_git_command_rtos: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: rtos command  !!!");
	$(Q)$(call sj_echo_log, warning , "using CMD=\"\"  !!!");
	cd $(SJ_PATH_PSDKRA)/ && $(CMD)
	$(Q)$(call sj_echo_log, info , "sdk_git: rtos command --done !!!");

sdk_git_command_all: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "sdk_git: uboot/kernel/rtos command  !!!");
	$(Q)$(call sj_echo_log, warning , "using CMD=\"\"  !!!");
	cd $(SJ_PATH_UBOOT)/ && $(CMD)
	cd $(SJ_PATH_KERNEL)/ && $(CMD)
	cd $(SJ_PATH_PSDKRA)/ && $(CMD)
	$(Q)$(call sj_echo_log, info , "sdk_git: uboot/kernel/rtos command --done !!!");

SDK_GIT_TYPE ?=add
SDK_GIT_NAME ?=ssh
sdk_git_setlocalurl: check_paths_PSDKLA  check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "1. sdk_git_setlocalurl ... : you can set the SDK_GIT_TYPE and SDK_GIT_NAME"); 
	$(Q)$(call sj_echo_log, help , "SDK_GIT_TYPE ", "$(SDK_GIT_TYPE)");
	$(Q)$(call sj_echo_log, help , "SDK_GIT_NAME ", "$(SDK_GIT_NAME)");
	cd $(SJ_PATH_UBOOT)/      && git remote $(SDK_GIT_TYPE) $(SDK_GIT_NAME) $(SJ_GIT_SERVER)/jacinto7/sdk_9x_uboot.git
	cd $(SJ_PATH_KERNEL)/     && git remote $(SDK_GIT_TYPE) $(SDK_GIT_NAME) $(SJ_GIT_SERVER)/jacinto7/sdk_9x_kernel.git
	cd $(SJ_PATH_PSDKRA)/     && git remote $(SDK_GIT_TYPE) $(SDK_GIT_NAME) $(SJ_GIT_SERVER)/jacinto7/rtos-j721s2-evm-$(SJ_PSDKRA_BRANCH).git
	$(Q)$(call sj_echo_log, info , "1. sdk_git_setlocalurl ... done! "); 

sdk_git_help:
	$(Q)$(call sj_echo_log, info , "1. sdk_git_help ... "); 
	$(Q)$(call sj_echo_log, info ,"# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "sdk_git_branch","check the sdk branch ... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_command_all", "sdk git command ... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_command_kernel", "sdk git kernel ... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_command_rtos", "sdk git rtos... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_command_uboot", "sdk git uboot ... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_status","sdk git status ... "); 
	$(Q)$(call sj_echo_log, help , "sdk_git_setlocalurl","set git server url ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. sdk_git_help ... done!"); 