########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
# Vision-SDK environment install 

ra-install-dependencies:
	cd $(PSDKRA_PATH); $(PSDKRA_PATH)/psdk_rtos_auto/scripts/setup_psdk_rtos_auto.sh

ra-ccs-setup-steps:
	$(Q)$(ECHO) "1. Please run below in scripts";
	$(Q)$(ECHO) "load(\"/home/fredy/j7/psdk_rtos_auto_j7_06_01_00_15/pdk/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"
	$(Q)$(ECHO) "load(\"/home/fredy/j7/ti-processor-sdk-rtos-j721e-evm-07_03_00_07/pdk_jacinto_07_03_00_29/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"
	$(Q)$(ECHO) "2. make sure the M3 has the gel file";
	$(Q)$(ECHO) "3. check the log happey debugging ！";
	

ra-install-targetfs: 
	cp ${PSDKLA_PATH}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${PSDKRA_PATH}/
	cp ${PSDKLA_PATH}/filesystem/tisdk-default-image-j7-evm.tar.xz     ${PSDKRA_PATH}/

ra-install-sdk: check_paths_downloads check_paths_PSDKLA
	# 1. download the package & install
	$(Q)if [ ! -d $(PSDKRA_PATH) ] ; then \
		if [ ! -f $(DOWNLOADS_PATH)/`echo $(PSDKRA_SDK_URL) | cut -d / -f 9` ] ; then \
			cd $(DOWNLOADS_PATH) && wget $(PSDKRA_INSTALL_PACKAGES_LINK); \
		else \
			echo "SDK alread download. "; \
		fi; \
		echo "2. untar the packages to target  dictory"; \
		cd $(DOWNLOADS_PATH) && tar -zxvf $(PSDKRA_PG_NAME).tar.gz -C $(J7_SDK_PATH); \
		sync; \
	else \
		echo "sdk already installed, continue..."; \
	fi
	# 3. Setup the git
	$(Q)if [ ! -d $(PSDKRA_PATH)/.git ] ; then \
		cd $(PSDKRA_PATH) && git init; \
		ln -s $(resouce_PATH)/psdkra/gitignore $(PSDKRA_PATH)/.gitignore ; \
		cd $(PSDKRA_PATH) && git add -A ; \
		cd $(PSDKRA_PATH) && git commit -m "repo init" ;\
	else \
		echo "Git already setup. "; \
	fi
	# 4. install the filesystem to PSDKRA path.  
	$(Q)if [ ! -f ${PSDKRA_PATH}/boot-j7-evm.tar.gz ] ; then \
		cp ${PSDKLA_PATH}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${PSDKRA_PATH} ; \
	else \
		echo "boot image already setup!"; \
	fi
	$(Q)if [ ! -f ${PSDKRA_PATH}/tisdk-default-image-j7-evm.tar.xz ] ; then \
		cp ${PSDKLA_PATH}/filesystem/tisdk-default-image-j7-evm.tar.xz ${PSDKRA_PATH} ; \
	else \
		echo "filesystem already setup!"; \
	fi
	sync
	# 5. install dependcy tools 
	cd ${PSDKRA_PATH} && ./psdk_rtos/scripts/setup_psdk_rtos.sh
	# 6. Ready to compiling. 
	# 7. install additional package: 
	#		a. downlaod the sdk
	#cd $(DOWNLOADS_PATH) && wget $(PSDKRA_ADD_ON_LINK)
	# 		b. install add on package for run PC demo. 
	#cd $(DOWNLOADS_PATH) && chmod a+x ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run 
	#cd $(DOWNLOADS_PATH) && cp ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run $(PSDKRA_PATH)/
	#cd $(PSDKRA_PATH) && ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run
	# PSDKRA Ready to use, congrations! 

ra-sd-mk-partition-method:
	@echo " >>>>> do SD mk partition as below:"
	@echo " >>>>> Use the command "df -h" to identify the device used by SD card"
	@echo " >>>>> option1: Unmount the SD card before running the script"
	@echo "                umount /dev/sdb1"
	@echo "                umount /dev/sdb1"
	@echo " >>>>>          cd ${PSDKRA_PATH} && sudo psdk_rtos_auto/scripts/mk-linux-card.sh /dev/sdb "
	@echo " >>>>>          end !!!  "
	@echo " >>>>> option2:  you can use "gparted" utility (sudo apt install gparted) to use a GUI based interface to create the partitions "
	@echo " >>>>>          Make sure you set the FAT32 partition flags as "boot", "lba" " 
	@echo " >>>>>          Name the FAT32 partition as "BOOT" and the ext4 partition as "rootfs" " 
	@echo " >>>>>          end !!!  "

ra-sd-mk-partition:
	sudo $(SCRIPTS_PATH)/mk-linux-card-psdkra.sh

ra-sd-install-rootfs: check_paths_sd_boot check_paths_sd_rootfs
	@echo "install the rootfs to SD card"
	@if [ ! -d $(PSDKRA_PATH)psdk_rtos_auto ] ; then \
		cd ${PSDKRA_PATH} && psdk_rtos/scripts/install_to_sd_card.sh; \
	else \
		cd ${PSDKRA_PATH} && psdk_rtos_auto/scripts/install_to_sd_card.sh; \
	fi
	sync
	@echo "install done!!!"
ra-sd-install-auto-ti_data: check_paths_sd_rootfs  check_paths_sd_boot 
	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$USER/rootfs/"
	mkdir -p $(ROOTFS)/opt/vision_apps
	cd $(ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(INSTALLER)/psdk_rtos_auto_ti_data_set_07_00_00.tar.gz
	@echo "install done!!!"

ra-sd-install-auto-ti-data_07_02: check_paths_sd_rootfs  check_paths_sd_boot 
	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$USER/rootfs/"
	mkdir -p $(ROOTFS)/opt/vision_apps
	cd $(ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(INSTALLER)/psdk_rtos_ti_data_set_07_02_00.tar.gz
	@echo "install done!!!"	

ra-sd-install-auto-ti-data_07_03: check_paths_sd_rootfs  check_paths_sd_boot 
	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$USER/rootfs/"
	mkdir -p $(ROOTFS)/opt/vision_apps
	cd $(ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(DOWNLOADS_PATH)/psdk_rtos_ti_data_set_07_03_00.tar.gz
	@echo "install done!!!"	


ra-sd-linux-fs-install-sd: check_paths_sd_rootfs  check_paths_sd_boot
	@echo "Do below to copy vision apps binaries to SD card"
	cd ${PSDKRA_PATH}/vision_apps && make linux_fs_install_sd
	@echo "install done!!!"	
	
#==============================================================================
# A help message target.
#==============================================================================
ra-install-help:
	@echo
	@echo "ra_install_help Available build targets are  :"
	@echo "    ----------------print_env --------------------------------------  "
	@echo "    ----------------------------------------------------------------  "
	@echo "    ----------------Build ------------------------------------------  "
	@echo "    sdk                     : To incrementally (or for the first time) build SDK"
	@echo "    sdk_scrub               : To clean SDK do below"
	@echo "    sdk_help                : To see additional build targets for SDK and component builds, do below"	
	@echo "    vision_apps             : Build all vision sdk Applications"

ra-sd-help:
	@echo
	@echo "ra_install_help Available build targets are  :"
	@echo "    ----------------print_env --------------------------------------  "
	@echo "    ----------------------------------------------------------------  "
	@echo "    ----------------Build ------------------------------------------  "
	@echo "    sdk                     : To incrementally (or for the first time) build SDK"
	@echo "    sdk_scrub               : To clean SDK do below"
	@echo "    sdk_help                : To see additional build targets for SDK and component builds, do below"	
	@echo "    vision_apps             : Build all vision sdk Applications"

.PHONY: 
