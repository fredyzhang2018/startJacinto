########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
# Vision-SDK environment install 

ra_install_dependencies:
	$(Q)$(call sj_echo_log, info , "1. ra_install_dependencies ... "); 
	cd $(SJ_PATH_PSDKRA); $(SJ_PATH_PSDKRA)/psdk_rtos/scripts/setup_psdk_rtos.sh
	$(Q)$(call sj_echo_log, info , "1. ra_install_dependencies ... done!"); 

ra_install_ccs_setup_steps:
	$(Q)$(call sj_echo_log, info , "1. ra_install_ccs_setup_steps ... "); 
	$(Q)$(ECHO) "1. Please run below in scripts";
	$(Q)$(ECHO) "loadJSFile(\"$(SJ_PATH_PDK)/packages/ti/drv/sciclient/tools/ccsLoadDmsc/$(SJ_SOC_TYPE)/launch.js\");"
	$(Q)$(ECHO) "2. make sure the M3/M4 has the gel file";
	$(Q)$(ECHO) "3. check the log happey debugging !";
	$(Q)$(call sj_echo_log, info , "1. ra_install_ccs_setup_steps ... done!"); 

ra_install_targetfs:
	$(Q)$(call sj_echo_log, info , "1. ra_install_targetfs ... "); 
ifeq ($(SJ_VER_SDK),09) 
	cp ${SJ_PATH_PSDKLA}/board-support/prebuilt-images/boot-adas-$(SJ_SOC_TYPE)-evm.tar.gz ${SJ_PATH_PSDKRA}/
	cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-adas-image-$(SJ_SOC_TYPE)-evm.tar.xz     ${SJ_PATH_PSDKRA}/
else
	cp ${SJ_PATH_PSDKLA}/board-support/prebuilt-images/boot-j7-evm.tar.gz ${SJ_PATH_PSDKRA}/
	cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-default-image-j7-evm.tar.xz     ${SJ_PATH_PSDKRA}/
	cp ${SJ_PATH_PSDKLA}/filesystem/tisdk-edgeai-image-j7-evm.tar.xz     ${SJ_PATH_PSDKRA}/
endif
	$(Q)$(call sj_echo_log, info , "1. ra_install_targetfs ... done!"); 

ra_sd_install_all: la_sd_linux_install la_sd_install_linux_dtbs la_gpu la_gpu_install_sd  ra_sd_linux_fs_install_sd la_sd_install_uboot
ra_nfs_install_all: la_nfs_linux_install la_nfs_install_linux_dtbs la_gpu la_gpu_install_nfs_psdkra ra_nfs_linux_fs_install_sd la_nfs_install_uboot

ra_install_sdk:check_paths_downloads check_paths_PSDKLA
	$(Q)$(call sj_echo_log, info , "1. ra_install_sdk ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk");
	./scripts/j7/install_psdkra.sh -s $(SJ_PSDKRA_BRANCH) -i yes -p $(SJ_PATH_SDK)
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk --done");
	$(Q)$(call sj_echo_log, info , "1. ra_install_sdk ... done!"); 

ra_install_dataset:check_paths_downloads check_paths_PSDKLA
	$(Q)$(call sj_echo_log, info , "1. ra_install_dataset ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk dataset");
	./scripts/j7/install_psdkra.sh -s $(SJ_PSDKRA_BRANCH) -d  yes -p $(SJ_PATH_SDK)
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk dataset --done");
	$(Q)$(call sj_echo_log, info , "1. ra_install_dataset ... done!"); 

ra_install_sdk_addon:check_paths_downloads check_paths_PSDKLA check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "1. ra_install_sdk_addon ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk addon");
	@if [ $(SJ_SOC_TYPE) == "j721e" ] ; then \
		echo "Install dictionary :  $(SJ_PATH_PSDKRA) ";\
		echo " ./download/*-addon-linux-x64-installer.run"	; \
		echo " install dictionary :  startjacinto/sdks/"	; \
	fi
	@if [ $(SJ_SOC_TYPE) == "j721s2" ] ; then \
		echo "Install dictionary :  $(SJ_PATH_PSDKRA) ";\
		echo " ./download/*-addon-linux-x64-installer.run"	; \
		echo " install dictionary :  startjacinto/sdks/"	; \
	fi
	$(Q)$(call sj_echo_log, info , " --- 1. setup the PSDKRA sdk add on done");
	$(Q)$(call sj_echo_log, info , "1. ra_install_sdk_addon ... done!"); 

ra_sd_mk_partition_method:
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mk_partition_method ... "); 
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
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mk_partition_method ... done!"); 

ra_sd_mk_partition:
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mk_partition ... "); 
	sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkra.sh
	$(Q)$(call sj_echo_log, info , "1. ra_sd_mk_partition ... done!"); 

ra_sd_install_rootfs: check_paths_sd_boot check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_rootfs ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0.  install the rootfs to sd card!");
	@if [ -d $(SJ_PATH_PSDKRA)/psdk_rtos_auto ] ; then \
		cd ${SJ_PATH_PSDKRA} && psdk_rtos/scripts/install_to_sd_card.sh; \
	elif [ -d $(SJ_PATH_PSDKRA)/sdk_builder ]; then  \
		cd ${SJ_PATH_PSDKRA} && sdk_builder/scripts/install_to_sd_card.sh; \
	else \
		cd ${SJ_PATH_PSDKRA} && psdk_rtos/scripts/install_to_sd_card.sh; \
	fi
	sync
	@echo "install done!!!"
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_rootfs ... done!"); 

ra_sd_install_tiny_rootfs: check_paths_sd_boot check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_tiny_rootfs ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0.  install the rootfs to SD card");
	cd ${SJ_PATH_PSDKRA} && ${SJ_PATH_SCRIPTS}/j7/install_to_sd_card_tiny.sh
	$(Q)$(call sj_echo_log, info , " --- 0.  install the rootfs to SD card --- Done");
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_tiny_rootfs ... done!"); 

ra_sd_install_prebuild_rootfs: check_paths_sd_boot check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_prebuild_rootfs ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1.  install the rootfs to SD card!");
	@if [ ! -d ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-$(SJ_SOC_TYPE)-evm-$(SJ_PSDKRA_BRANCH)-prebuilt ] ; then \
		cd ${SJ_PATH_PSDKRA}  && tar -zxvf ti-processor-sdk-rtos-$(SJ_SOC_TYPE)-evm-$(SJ_PSDKRA_BRANCH)-prebuilt.tar.gz; \
	else \
		echo "- ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-$(SJ_SOC_TYPE)-evm-$(SJ_PSDKRA_BRANCH)-prebuilt already installed ! "; 	 \
		cd ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-$(SJ_SOC_TYPE)-evm-$(SJ_PSDKRA_BRANCH)-prebuilt && ./install_to_sd_card.sh ;    \
		cd ${SJ_PATH_PSDKRA}/ti-processor-sdk-rtos-$(SJ_SOC_TYPE)-evm-$(SJ_PSDKRA_BRANCH)-prebuilt && ./install_data_set_to_sd_card.sh $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_`echo $(SJ_PSDKRA_BRANCH) | cut -c 1-8`.tar.gz;    \
	fi
	sync
	$(Q)$(call sj_echo_log, info , " --- 1.  rootfs data set install done!!!");
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_prebuild_rootfs ... done!"); 

ra_sd_install_auto_ti_data: check_paths_sd_rootfs  check_paths_sd_boot 
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_auto_ti_data ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0.  Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$(USER)/rootfs/");
	cd ${SJ_PATH_PSDKRA} && ${SJ_PATH_SCRIPTS}/j7/install_psdkra_ti_data.sh  -i yes -s  $(SJ_PSDKRA_BRANCH)
	$(Q)$(call sj_echo_log, info , " --- 0.  Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$(USER)/rootfs/ --- Done");
	$(Q)$(call sj_echo_log, info , "1. ra_sd_install_auto_ti_data ... done!"); 
# 	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$(USER)/rootfs/"
# 	mkdir -p $(SJ_ROOTFS)/opt/vision_apps
# ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_04_00_06)
# 	echo "$(SJ_PSDKRA_PG_NAME)"
# 	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_04_00.tar.gz
# endif	
# ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_01_00_11)
# 	echo "$(SJ_PSDKRA_PG_NAME)"
# 	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_01_00.tar.gz
# endif		
# ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-08_00_00_12)
# 	echo "$(SJ_PSDKRA_PG_NAME)"
# 	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_08_00_00.tar.gz
# endif
# ifeq ($(SJ_PSDKRA_PG_NAME),ti-processor-sdk-rtos-j721e-evm-07_03_00_07)
# 	echo "$(SJ_PSDKRA_PG_NAME)"
# 	cd $(SJ_ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(SJ_PATH_DOWNLOAD)/psdk_rtos_ti_data_set_07_03_00.tar.gz
# endif
# 	@sync
# 	@echo "install done!!!"


ra_sd_linux_fs_install_sd: check_paths_sd_rootfs  check_paths_sd_boot
	$(Q)$(call sj_echo_log, info , "1. ra_sd_linux_fs_install_sd ... "); 
	@echo "Do below to copy vision apps binaries to SD card"
	$(MAKE) -C ${SJ_PATH_VISION_SDK_BUILD}/ linux_fs_install_sd
	@echo "install done!!!"	
	$(Q)$(call sj_echo_log, info , "1. ra_sd_linux_fs_install_sd ... done!"); 

ra_nfs_linux_fs_install: 
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir ... ");
	$(MAKE) -C ${SJ_PATH_VISION_SDK_BUILD}/ linux_fs_install_nfs
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir ... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install ... done!"); 

ra_nfs_linux_fs_install_edgeai: 
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install_edgeai ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir edgeai... ");
	$(MAKE) -C ${SJ_PATH_PSDKRA}/vision_apps BUILD_EDGEAI=yes linux_fs_install_nfs
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir edgeai ... done!!!");
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install_edgeai ... done!"); 

ra_nfs_linux_fs_install_testdata: 
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install_testdata ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir test data ... ");
	$(MAKE) -C ${SJ_PATH_VISION_SDK_BUILD} linux_fs_install_nfs_test_data
	$(Q)$(call sj_echo_log, info , " --- 0. Do below to copy vision apps binaries to nfs targetfs dir test data ... done!!!");
	$(Q)$(call sj_echo_log, info , "1. ra_nfs_linux_fs_install_testdata ... done!"); 

ra_sd_linux_fs_install_scp:
	$(Q)$(call sj_echo_log, info , "1. ra_sd_linux_fs_install_scp ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_update_vision_sdk.sh --ip $(SJ_EVM_IP) ------------------------------- start !!!");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) linux_fs_install -s -j$(CPU_NUM) 
	cd $(SJ_PATH_SCRIPTS)/j7 &&  ./remote_update_vision_sdk.sh --ip $(SJ_EVM_IP)
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_update_vision_sdk.sh --ip $(SJ_EVM_IP) ------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. ra_sd_linux_fs_install_scp ... done!"); 

# KEY_WRITER_VERSION ?=OTP_KEYWRITER_ADD_ON_j721e_v2021.05b-linux-installer.run
KEY_WRITER_VERSION ?=OTP_KEYWRITER_ADD_ON_j721e_sr1_1_v2021.05b-linux-installer.run
KEY_WRITER_ADDON ?=https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$(SJ_PSDKRA_BRANCH)/exports/keywriter_patch.tar.gz
ra_install_keywriter: check_paths_PSDKRA #check_paths_sd_boot
	$(Q)$(call sj_echo_log, info , "1. ra_install_keywriter ... "); 
	$(Q)$(call sj_echo_log, info , " 0. downnload the keywriter: https://www.ti.com/securesoftware/docs/securesoftware download from here !!!");
	$(Q)$(call sj_echo_log, info , " 1. install the keywriter: cd $(SJ_PATH_SCRIPTS)/j7/install_keywriter.sh  !!!");
	$(Q)cd $(SJ_PATH_SCRIPTS)/j7/ && ./install_keywriter.sh  --ver $(SJ_PATH_DOWNLOAD)/$(KEY_WRITER_VERSION) -p $(SJ_PATH_PDK) -a $(KEY_WRITER_ADDON)
	# $(Q)cd $(SJ_PATH_SCRIPTS)/j7/ && ./install_keywriter.sh  --ver $(SJ_PATH_DOWNLOAD)/$(KEY_WRITER_VERSION) -p $(SJ_PATH_PDK) # test for SDK8.2
	$(Q)$(call sj_echo_log, info , " 1. install key keywriter done   !!!");
	$(Q)$(call sj_echo_log, info , " 2. update the image to SD card  !!!");
	# cp $(SJ_PATH_PDK)/packages/ti/boot/keywriter/binary/j721e/keywriter_img_j721e_release.bin $(SJ_BOOT)/tiboot3.bin
	# cp $(SJ_PATH_PDK)/packages/ti/boot/keywriter/tifs_bin/j721e/ti-fs-keywriter.bin           $(SJ_BOOT)/tifs.bin
	$(Q)$(call sj_echo_log, info , " 2. update the image to SD card --done !!!");
	$(Q)$(call sj_echo_log, info , " 3. Userguide :  https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/08_01_00_13/exports/docs/pdk_jacinto_08_01_00_36/docs/userguide/jacinto/modules/keywriter.html  !!!");
	$(Q)$(call sj_echo_log, info , "1. ra_install_keywriter ... done!"); 

ra_memory_update:
	$(Q)$(call sj_echo_log, info , "1. ra_memory_update ... "); 
	$(Q)$(call sj_echo_log, info , " 0. start to update the memory ... : $(SJ_PATH_PSDKRA)/vision_apps/platform/$(SJ_SOC_TYPE)/rtos/app_mem_map.h");
	$(Q)$(call sj_echo_log, info , " 1. install the tools ...");
	cd $(SJ_PATH_PSDKRA)/vision_apps/tools/PyTI_PSDK_RTOS && pip3 install -e . --user
	$(Q)$(call sj_echo_log, info , " 1. install the tools ... done!!!");
	$(Q)$(call sj_echo_log, info , " 2. update memory ...");
	cd $(SJ_PATH_PSDKRA)/vision_apps/platform/$(SJ_SOC_TYPE)/rtos && ./gen_linker_mem_map.py
	ls -l $(SJ_PATH_PSDKRA)/vision_apps/platform/$(SJ_SOC_TYPE)/rtos
	$(Q)$(call sj_echo_log, info , " 2. update memory ... done!!!");
	$(Q)$(call sj_echo_log, info , " 0. start to update the memory ... done!!!");
	$(Q)$(call sj_echo_log, info , "1. ra_memory_update ... done!"); 

ra_hs_check_uart_boot_log: 
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_minicom ... "); 
	$(Q)$(call sj_echo_log, info , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")
	python3 $(SJ_PATH_SCRIPTS)/j7/hs/uart_boot_socid.py $(SJ_PATH_SCRIPTS)/j7/hs/default_uart_hs.log
	$(Q)$(call sj_echo_log, info , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_minicom ... done!"); 


ra_hs_check_uart_boot_log_input: 
	$(Q)$(call sj_echo_log, info , "1. ra_hs_check_uart_boot_log_input ... "); 
	$(Q)$(call sj_echo_log, info , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")
	python3 $(SJ_PATH_SCRIPTS)/j7/hs/uart_boot_socid.py $(log)
	$(Q)$(call sj_echo_log, info , " 0. anlysis hs log : uart_boot_socid.py uart_log_file")
	$(Q)$(call sj_echo_log, info , "1. ra_hs_check_uart_boot_log_input ... done!"); 


#==============================================================================
# A help message target.
#==============================================================================
ra_help_install:
	$(Q)$(call sj_echo_log, info , "1. ra_help_install ... "); 
	$(Q)$(call sj_echo_log, info ,"# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "ra_install_dependencies","install sdk dependencies ... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_ccs_setup_steps", "print the ccs setup steps ... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_targetfs", "install the PSDKLA filesytem to PSDKRA ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_install_all", " install all to filesystem ... "); 
	$(Q)$(call sj_echo_log, help , "ra_nfs_install_all", "nfs install ... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_sdk", " install psdkra sdk... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_dataset","install psdkra sdk dataset ... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_sdk_addon", "install psdkra sdk adds-on ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_mk_partition_method","print method mk partition ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_mk_partition", "sd card: make partition ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_install_rootfs", "install rootfs to sd ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_install_tiny_rootfs", "install tiny fs to sd ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_install_prebuild_rootfs", "install prebuild rootfs ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_install_auto_ti_data","install ti data to sd ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_linux_fs_install_sd", "install psdkra build ... "); 
	$(Q)$(call sj_echo_log, help , "ra_nfs_linux_fs_install", "nfs psdkra install ... "); 
	$(Q)$(call sj_echo_log, help , "ra_nfs_linux_fs_install_edgeai", "nfs psdkra install edgeai..."); 
	$(Q)$(call sj_echo_log, help , "ra_nfs_linux_fs_install_testdata", "nfs psdkra install testdata ... "); 
	$(Q)$(call sj_echo_log, help , "ra_sd_linux_fs_install_scp", " update later ... "); 
	$(Q)$(call sj_echo_log, help , "ra_install_keywriter", "install key writer  ... "); 
	$(Q)$(call sj_echo_log, help , "ra_memory_update", "PSDKRA memory updating ... "); 
	$(Q)$(call sj_echo_log, help , "ra_hs_check_uart_boot_log",  "hs check uart log ... "); 
	$(Q)$(call sj_echo_log, help , "ra_hs_check_uart_boot_log_input","hs check uart log: input \$ ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. ra_help_install ... done!"); 

.PHONY: 
