########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
# Vision-SDK environment install 

ra-install-dependencies:
	cd $(PSDKRA_PATH); $(PSDKRA_PATH)/psdk_rtos_auto/scripts/setup_psdk_rtos_auto.sh

ra-install-ccs_scripts:
	@echo "Please run below in scripts";
	@echo "load(\"/home/fredy/j7/psdk_rtos_auto_j7_06_00_01_00/pdk/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"

ra-install-targetfs: 
	cp ${PSDKLA_PATH}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${PSDKRA_PATH}/
	cp ${PSDKLA_PATH}/filesystem/tisdk-default-image-j7-evm.tar.xz     ${PSDKRA_PATH}/

ra-install-sdk: check_paths_downloads check_paths_PSDKLA
	# 1. download the package:
	#cd $(DOWNLOADS_PATH) && wget $(PSDKRA_INSTALL_PACKAGES_LINK)
	# 2. tar to target dictory
	#cd $(DOWNLOADS_PATH) && tar -zxvf $(PSDKRA_PG_NAME).tar.gz -C $(J7_SDK_PATH)
	cd $(PSDKRA_PATH) && git init
	cd $(PSDKRA_PATH) && git add -A 
	cd $(PSDKRA_PATH) && git commit -m "repo init"
	# 3. install the filesystem to PSDKRA path.  
	cp ${PSDKLA_PATH}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${PSDKRA_PATH}/
	cp ${PSDKLA_PATH}/filesystem/tisdk-default-image-j7-evm.tar.xz     ${PSDKRA_PATH}/
	sync
	# 4. install dependcy tools 
	cd ${PSDKRA_PATH} && ./psdk_rtos/scripts/setup_psdk_rtos.sh
	# 5. Ready to compiling. 
	# 6. install additional package: 
	#		a. cd $(DOWNLOADS_PATH) && wget $(PSDKRA_ADD_ON_LINK)
	# 		b. install add on package for run PC demo. 
	#			cd $(DOWNLOADS_PATH) && chmod a+x ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run 
	#			cd $(DOWNLOADS_PATH) && cp ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run $(PSDKRA_PATH)/
	#			cd $(PSDKRA_PATH) && ./$(PSDKRA_PG_NAME)-addon-linux-x64-installer.run

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
