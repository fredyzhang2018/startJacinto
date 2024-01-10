#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

adb-device: 
	$(Q)$(call sj_echo_log, 0 , "adb: adb devices.  !!!");
	adb devices
	$(Q)$(call sj_echo_log, 0 , "adb: adb devices. --done !!!");


adb-reboot: 
	$(Q)$(call sj_echo_log, 0 , "adb: adb devices.  !!!");
	adb shell reboot
	$(Q)$(call sj_echo_log, 0 , "adb: adb devices. --done !!!");

adb-setup-onboard-ti:  check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, 0 , "adb: setup need manually setup...  !!!");
	$(Q)$(call sj_echo_log, 0 , "adb: cp below to sd !!!");
	cp -rv $(SJ_PATH_TOOLS)/adb/lib_$(SJ_SOC_TYPE)_adb /home/root
	cp -rv $(SJ_PATH_TOOLS)/adb/adb_new.sh             /home/root
	cp -rv $(SJ_PATH_TOOLS)/adb/adb_setup_dep.sh       /home/root
	$(Q)$(call sj_echo_log, 0 , "adb:cp below to sd  !!!");
	echo "/home/root/adb_setup_dep.sh"
	$(Q)$(call sj_echo_log, 0 , "adb: setup lib...  done !!!");
	$(Q)$(call sj_echo_log, 0 , "adb: start the application!!!"
	echo "/home/root/adb_new.sh start"  
	$(Q)$(call sj_echo_log, 0 , "adb: start the application -done !!!"

adb-setup-onboard-user:  check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, 0 , "adb: setup need manually setup...  !!!");
	$(Q)$(call sj_echo_log, 0 , "adb: setup lib and service !!!");
	cd $(SJ_PATH_TOOLS)/adb/ && ./adb_setup.sh
	$(Q)$(call sj_echo_log, 0 , "adb: setup lib and service !!!");


adb-push-applications:
	$(Q)$(call sj_echo_log, 0 , "adb: updating applications...  !!!");
	adb push $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/release/*.out /opt/vision_apps/
	$(Q)$(call sj_echo_log, 0 , "adb: updating applications...  !!!");

adb-help:
	$(Q)$(ECHO)
	$(Q)$(ECHO) " adb ......   :"
	$(Q)$(ECHO) "    ----------------Build --------------------------------------  "
	$(Q)$(ECHO) "    adb-device    "
	$(Q)$(ECHO) "    ubuntu-docker-install   "
	$(Q)$(ECHO) "    ubuntu-docker-test       "
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "
