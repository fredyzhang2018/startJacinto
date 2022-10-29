########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
# Vision-SDK environment install 

ra-install-dependencies:
	cd $(SJ_PATH_PSDKRA); $(SJ_PATH_PSDKRA)/psdk_rtos_auto/scripts/setup_psdk_rtos_auto.sh

ra-ccs-setup-steps:
	$(Q)$(ECHO) "1. Please run below in scripts";
	$(Q)$(ECHO) "load(\"/home/fredy/j7/psdk_rtos_auto_j7_06_01_00_15/pdk/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"
	$(Q)$(ECHO) "load(\"/home/fredy/j7/ti-processor-sdk-rtos-j721e-evm-07_03_00_07/pdk_jacinto_07_03_00_29/packages/ti/drv/sciclient/tools/ccsLoadDmsc/j721e/launch.js\");"
	$(Q)$(ECHO) "2. make sure the M3 has the gel file";
	$(Q)$(ECHO) "3. check the log happey debugging ！";
	

ra-install-targetfs: 
	cp ${SJ_PATH_PSDKLA}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${SJ_PATH_PSDKRA}/
	cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-default-image-j7-evm.tar.xz     ${SJ_PATH_PSDKRA}/

ra-install-sdk:check_paths_downloads check_paths_PSDKLA
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the PSDKRA sdk");
	./scripts/j7/install_psdkra.sh -s $(SJ_PSDKRA_BRANCH) -i yes -p $(SJ_PATH_J7_SDK)
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the PSDKRA sdk --done");

ra-install-sdk1: check_paths_downloads check_paths_PSDKLA
	# 1. download the package & install
	$(Q)if [ ! -d $(SJ_PATH_PSDKRA) ] ; then \
		if [ ! -f $(SJ_PATH_DOWNLOAD)/`echo $(SJ_PSDKRA_SDK_URL) | cut -d / -f 9` ] ; then \
			# cd $(SJ_PATH_DOWNLOAD) && wget $(SJ_PSDKRA_INSTALL_PACKAGES_LINK); \
			echo "test"; \
		else \
			echo "SDK alread download. "; \
		fi; \
		echo "2. untar the packages to target  dictory"; \
		cd $(SJ_PATH_DOWNLOAD) && tar -zxvf $(SJ_PSDKRA_PG_NAME).tar.gz -C $(SJ_PATH_J7_SDK); \
		sync; \
	else \
		echo "sdk already installed, continue..."; \
	fi
	# 3. Setup the git
	$(Q)if [ ! -d $(SJ_PATH_PSDKRA)/.git ] ; then \
		cd $(SJ_PATH_PSDKRA) && git init; \
		ln -s $(SJ_PATH_RESOURCE)/psdkra/gitignore $(SJ_PATH_PSDKRA)/.gitignore ; \
		cd $(SJ_PATH_PSDKRA) && git add -A ; \
		cd $(SJ_PATH_PSDKRA) && git commit -m "repo init" ;\
	else \
		echo "Git already setup. "; \
	fi
	# 4. install the filesystem to PSDKRA path.  
	$(Q)if [ ! -f ${SJ_PATH_PSDKRA}/boot-j7-evm.tar.gz ] ; then \
		cp ${SJ_PATH_PSDKLA}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${SJ_PATH_PSDKRA} ; \
	else \
		echo "boot image already setup!"; \
	fi
	$(Q)if [ ! -f ${SJ_PATH_PSDKRA}/tisdk-default-image-j7-evm.tar.xz ] ; then \
		cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-default-image-j7-evm.tar.xz ${SJ_PATH_PSDKRA} ; \
	else \
		echo "filesystem already setup!"; \
	fi
	sync
	# 5. install dependcy tools 
	cd ${SJ_PATH_PSDKRA} && ./psdk_rtos/scripts/setup_psdk_rtos.sh
	# 6. install the ti data. 
	cd $(SJ_PATH_DOWNLOAD) && wget $(SJ_PSDKRA_TI_DATA_DOWNLOAD_LINK)
	# 7. Ready to compiling. 
	# 8. install additional package: 
	#		a. downlaod the sdk
	#cd $(SJ_PATH_DOWNLOAD) && wget $(SJ_PSDKRA_ADD_ON_LINK)
	# 		b. install add on package for run PC demo. 
	#cd $(SJ_PATH_DOWNLOAD) && chmod a+x ./$(SJ_PSDKRA_PG_NAME)-addon-linux-x64-SJ_INSTALLER.run 
	#cd $(SJ_PATH_DOWNLOAD) && cp ./$(SJ_PSDKRA_PG_NAME)-addon-linux-x64-SJ_INSTALLER.run $(SJ_PATH_PSDKRA)/
	#cd $(SJ_PATH_PSDKRA) && ./$(SJ_PSDKRA_PG_NAME)-addon-linux-x64-SJ_INSTALLER.run
	# PSDKRA Ready to use, congrations! 

ra-sd-mk-partition-method:
	@echo " >>>>> do SD mk partition as below:"
	@echo " >>>>> Use the command "df -h" to identify the device used by SD card"
	@echo " >>>>> option1: Unmount the SD card before running the script"
	@echo "                umount /dev/sdb1"
	@echo "                umount /dev/sdb1"
	@echo " >>>>>          cd ${SJ_PATH_PSDKRA} && sudo psdk_rtos_auto/scripts/mk-linux-card.sh /dev/sdb "
	@echo " >>>>>          end !!!  "
	@echo " >>>>> option2:  you can use "gparted" utility (sudo apt install gparted) to use a GUI based interface to create the partitions "
	@echo " >>>>>          Make sure you set the FAT32 partition flags as "boot", "lba" " 
	@echo " >>>>>          Name the FAT32 partition as "BOOT" and the ext4 partition as "rootfs" " 
	@echo " >>>>>          end !!!  "

ra-sd-mk-partition:
	sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkra.sh

ra-sd-install-rootfs: check_paths_sd_boot check_paths_sd_rootfs
	@echo "install the rootfs to SD card"
	@if [ ! -d $(SJ_PATH_PSDKRA)psdk_rtos_auto ] ; then \
		cd ${SJ_PATH_PSDKRA} && psdk_rtos/scripts/install_to_sd_card.sh; \
	else \
		cd ${SJ_PATH_PSDKRA} && psdk_rtos_auto/scripts/install_to_sd_card.sh; \
	fi
	sync
	@echo "install done!!!"

ra-sd-install-prebuild-rootfs: check_paths_sd_boot check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, 0 , " --- 1.  install the rootfs to SD card!");
	@if [ ! -d ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-j721e-evm-$(SJ_PSDKRA_BRANCH)-prebuilt ] ; then \
		cd ${SJ_PATH_PSDKRA}  && tar -zxvf ti-processor-sdk-rtos-j721e-evm-$(SJ_PSDKRA_BRANCH)-prebuilt.tar.gz; \
	else \
		echo "- ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-j721e-evm-$(SJ_PSDKRA_BRANCH)-prebuilt already installed ! "; 	 \
		cd ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-j721e-evm-$(SJ_PSDKRA_BRANCH)-prebuilt && ./install_to_sd_card.sh ;    \
	fi
	sync
	$(Q)$(call sj_echo_log, 0 , " --- 1.  rootfs data set install done!!!");

SJ_PSDKRA_PG_NAME=ti-processor-sdk-rtos-j721e-evm-08_04_00_11
ra-sd-install-auto-ti-data: check_paths_sd_rootfs  check_paths_sd_boot 
	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$(USER)/rootfs/"
	mkdir -p $(SJ_ROOTFS)/opt/vision_apps
ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_04_00_11)
	echo "$(SJ_PSDKRA_PG_NAME)"
	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_01_00.tar.gz
endif	
ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_01_00_11)
	echo "$(SJ_PSDKRA_PG_NAME)"
	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_01_00.tar.gz
endif		
ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_00_00_12)
	echo "$(SJ_PSDKRA_PG_NAME)"
	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_00_00.tar.gz
endif
ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-07_03_00_07)
	echo "$(SJ_PSDKRA_PG_NAME)"
	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_07_03_00.tar.gz
endif
	@sync
	@echo "install done!!!"


ra-sd-linux-fs-install-sd: check_paths_sd_rootfs  check_paths_sd_boot
	@echo "Do below to copy vision apps binaries to SD card"
	$(MAKE) -C ${SJ_PATH_PSDKRA}/vision_apps linux_fs_install_sd
	@echo "install done!!!"	

ra-sd-linux-fs-install-scp:
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_update_vision_sdk.sh --ip $(SJ_EVM_IP) ------------------------------- start !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) linux_fs_install -s -j$(CPU_NUM) 
	cd $(SJ_PATH_SCRIPTS)/j7 &&  ./remote_update_vision_sdk.sh --ip $(SJ_EVM_IP)
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_update_vision_sdk.sh --ip $(SJ_EVM_IP) ------------------------------- done !!!");

# KEY_WRITER_VERSION ?=OTP_KEYWRITER_ADD_ON_j721e_v2021.05b-linux-installer.run
KEY_WRITER_VERSION ?=OTP_KEYWRITER_ADD_ON_j721e_sr1_1_v2021.05b-linux-installer.run
KEY_WRITER_ADDON ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$(SJ_PSDKRA_BRANCH)/exports/keywriter_patch.tar.gz
ra-install-keywriter: check_paths_PSDKRA #check_paths_sd_boot
	$(Q)$(call sj_echo_log, 0 , " 0. downnload the keywriter: https://www.ti.com/securesoftware/docs/securesoftware download from here !!!");
	$(Q)$(call sj_echo_log, 0 , " 1. install the keywriter: cd $(SJ_PATH_SCRIPTS)/j7/install_keywriter.sh  !!!");
	$(Q)cd $(SJ_PATH_SCRIPTS)/j7/ && ./install_keywriter.sh  --ver $(SJ_PATH_DOWNLOAD)/$(KEY_WRITER_VERSION) -p $(SJ_PATH_PDK) -a $(KEY_WRITER_ADDON)
	# $(Q)cd $(SJ_PATH_SCRIPTS)/j7/ && ./install_keywriter.sh  --ver $(SJ_PATH_DOWNLOAD)/$(KEY_WRITER_VERSION) -p $(SJ_PATH_PDK) # test for SDK8.2
	$(Q)$(call sj_echo_log, 0 , " 1. install key keywriter done   !!!");
	$(Q)$(call sj_echo_log, 0 , " 2. update the image to SD card  !!!");
	# cp $(SJ_PATH_PDK)/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin $(SJ_BOOT)/tiboot3.bin
	# cp $(SJ_PATH_PDK)/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin           $(SJ_BOOT)/tifs.bin
	$(Q)$(call sj_echo_log, 0 , " 2. update the image to SD card --done !!!");
	$(Q)$(call sj_echo_log, 0 , " 3. Userguide :  https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_01_00_13/exports/docs/pdk_jacinto_08_01_00_36/docs/userguide/jacinto/modules/keywriter.html  !!!");


ra-hs-check-uart-boot-log: 
	$(Q)$(call sj_echo_log, 0 , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")
	python3 $(SJ_PATH_SCRIPTS)/j7/hs/uart_boot_socid.py $(SJ_PATH_SCRIPTS)/j7/hs/default_uart_hs.log
	$(Q)$(call sj_echo_log, 0 , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")





#==============================================================================
# A help message target.
#==============================================================================
ra-install-help:
	@echo
	@echo "ra_install_help Available build targets are  :"
	@echo "    ----------------print_env --------------------------------------  "
	@echo "    ----------------------------------------------------------------  "
	@echo "    ----------------Build ------------------------------------------  "
	@echo "    ra-install-dependencies           : install sdk dependencies"
	@echo "    ra-ccs-setup-steps                : print the ccs setup steps"
	@echo "    ra-install-targetfs               : install the PSDKLA filesytem to PSDKRA"	
	@echo "    ra-install-sdk                    : Install SDKs"

ra-sd-help:
	@echo
	@echo "ra_install_help Available build targets are  :"
	@echo "    ----------------print_env --------------------------------------  "
	@echo "    ----------------------------------------------------------------  "
	@echo "    ----------------Build ------------------------------------------  "
	@echo "    ra-sd-mk-partition-method                   : print SD card partition method."
	@echo "    ra-sd-mk-partition                          : make sd card parttion"
	@echo "    ra-sd-install-rootfs                        : install filesystem to SD card"	
	@echo "    ra-sd-install-auto-ti-data                  : install the auto ti data"
	@echo "    ra-sd-linux-fs-install-sd               	   : install images to SD card"
	@echo "    ra-sd-linux-fs-install-sd-debug             : install the debug version images to SD card"
	@echo "    ra-sd-linux-fs-install-sd                   : install the auto ti data"
	@echo "    ra-sd-linux-fs-install-sd-test-data         : --> internal using"

.PHONY: 
