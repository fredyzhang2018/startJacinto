#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

adb_device: 
	$(Q)$(call sj_echo_log, info , "adb: adb devices.  !!!");
	adb devices
	$(Q)$(call sj_echo_log, info , "adb: adb devices. --done !!!");

adb_shell: 
	$(Q)$(call sj_echo_log, info , "adb: adb devices.  !!!");
	adb shell
	$(Q)$(call sj_echo_log, info , "adb: adb devices. --done !!!");
	
adb_run_cmd: 
	$(Q)$(call sj_echo_log, info , "adb: adb_run_cmd  $(CMD) !!!");
	adb shell $(CMD)
	$(Q)$(call sj_echo_log, info , "adb: adb devices. --done !!!");
	
adb_reboot: 
	$(Q)$(call sj_echo_log, info , "adb: adb devices.  !!!");
	adb shell reboot
	$(Q)$(call sj_echo_log, info , "adb: adb devices. --done !!!");

adb_setup_onboard_ti:  check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "adb: setup need manually setup...  !!!");
	$(Q)$(call sj_echo_log, info , "adb: cp below to sd !!!");
	cp -rv $(SJ_PATH_TOOLS)/adb/lib_$(SJ_SOC_TYPE)_adb /home/root
	cp -rv $(SJ_PATH_TOOLS)/adb/adb_new.sh             /home/root
	cp -rv $(SJ_PATH_TOOLS)/adb/adb_setup_dep.sh       /home/root
	$(Q)$(call sj_echo_log, info , "adb:cp below to sd  !!!");
	echo "/home/root/adb_setup_dep.sh"
	$(Q)$(call sj_echo_log, info , "adb: setup lib...  done !!!");
	$(Q)$(call sj_echo_log, info , "adb: start the application!!!"
	echo "/home/root/adb_new.sh start"  
	$(Q)$(call sj_echo_log, info , "adb: start the application -done !!!"

adb_setup_onboard_user:  check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "adb: setup need manually setup...  !!!");
	$(Q)$(call sj_echo_log, info , "adb: setup lib and service !!!");
	cd $(SJ_PATH_TOOLS)/adb/ && ./adb_setup.sh 
	$(Q)$(call sj_echo_log, info , "adb: setup lib and service !!!");

adb_setup_psdkra_nfs: 
	$(Q)$(call sj_echo_log, info , "adb: setup need manually setup...  !!!");
	$(Q)$(call sj_echo_log, info , "adb: setup lib and service !!!");
	cd $(SJ_PATH_TOOLS)/adb/ && ./adb_setup_psdkra_nfs.sh 
	$(Q)$(call sj_echo_log, info , "adb: setup lib and service !!!");

adb_push_applications:
	$(Q)$(call sj_echo_log, info , "adb: updating applications...  !!!");
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/debug/*.out /opt/vision_apps/
	$(Q)$(call sj_echo_log, info , "adb: updating applications...  !!!");
adb_push_gpu_testing:
	$(Q)$(call sj_echo_log, info , "adb: updating image...  !!!");
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/debug/vx_app_bmp_gpu_display.out /opt/vision_apps
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/debug/vx_app_bmp_image_display.out /opt/vision_apps
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/debug/vx_gpu_test.out /opt/vision_apps
	adb push $(SJ_PATH_JACINTO)/sdks1/QT/showImage/showImage /opt/vision_apps
	$(Q)$(call sj_echo_log, info , "adb: updating image...  done!!!");
adb_push_kernel:
	adb push $(SJ_PATH_PSDKLA)/board-support/built-images/Image /boot

adb_push_fan_testing:
	$(Q)$(call sj_echo_log, info , "adb: updating image...  !!!");
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/debug/vx_app_fan* /opt/vision_apps
	adb push $(SJ_PATH_PSDKRA)/vision_apps/apps/basic_demos/app_fan_display/config/* /opt/vision_apps
	$(Q)$(call sj_echo_log, info , "adb: updating image...  done!!!");


adb_shell_run_show_image:	
	$(Q)$(call sj_echo_log, info , "adb: updating image...  !!!");
	adb push $(SJ_PATH_JACINTO)/sdks1/QT/showImage/showImage /home/root
	$(Q)$(call sj_echo_log, info , "adb: updating image...  done !!!");
	$(Q)$(call sj_echo_log, debug , "adb: ruhning showImage..  !!!");
	adb shell cd /home/root;
	adb shell  /home/root/showImage -platform offscreen
	$(Q)$(call sj_echo_log, debug , "adb: ruhning showImage..  done !!!");

adb_shell_run_vision:
	$(Q)$(call sj_echo_log, info , "adb: updating running script... $(SJ_PATH_SCRIPTS)/j7/remote_run.sh !!!");
	adb push $(SJ_PATH_SCRIPTS)/j7/remote_run.sh /home/root
	$(Q)$(call sj_echo_log, info , "adb: updating running script...  done!!!");
	$(Q)$(call sj_echo_log, info , "adb: running vision apps init... !!!");
	adb shell /home/root/remote_run.sh
	$(Q)$(call sj_echo_log, info , "adb: running vision apps init...  done!!!");

adb_shell_run_helloworld: 
	$(Q)$(call sj_echo_log, info , "adb: updating resources...  !!!");

adb_push_resources:
	$(Q)$(call sj_echo_log, info , "adb: updating resources...  !!!");
	adb push $(SJ_PATH_RESOURCE)/psdkra/$(SJ_PSDKRA_BRANCH)/*  /
	$(Q)$(call sj_echo_log, info , "adb: updating resources... done !!!");

fastboot_devices:
	$(Q)$(call sj_echo_log, info , "1. fastboot_devices... ");
	$(Q)$(call sj_echo_log, debug , "checking fastboot devices... ");
	$(Q)sudo fastboot devices
	$(Q)$(call sj_echo_log, info , "1. fastboot_devices... done!");


adb_help:
	$(Q)$(call sj_echo_log, info , "# adb Help....."); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "adb_device       ", "list the adb devices."); 
	$(Q)$(call sj_echo_log, help , "adb_shell        ", "adb shell."); 
	$(Q)$(call sj_echo_log, help , "adb_run_cmd      ", "adb_run_cmd CMD=... "); 
	$(Q)$(call sj_echo_log, help , "adb_reboot       ", "reboot the system..."); 
	$(Q)$(call sj_echo_log, help , "adb_push_resources", "adb push resources ..."); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "# adb Help..... done!"); 