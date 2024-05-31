########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries    
#                                                      #
########################################################

la_install_ubuntu_lib:
	$(Q)$(call sj_echo_log, info , "1. la_install_ubuntu_lib ... "); 
	$(Q)$(call sj_echo_log, info , " 1. setup the PSDKLA sdk dependcy lib ... ");
	#sudo apt-get install build-essential autoconf automake bison flex libssl-dev bc u-boot-tools python diffstat texinfo gawk chrpath dos2unix wget unzip socat doxygen libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386 g++-multilib
	$(Q)$(call sj_echo_log, info , " 1. setup the PSDKLA sdk dependcy lib ... done!");
	$(Q)$(call sj_echo_log, info , " 1. setup the PSDKLA sdk config dash... ");
	$(Q)echo "Congure your ENV Dash (Be sure to select “No” when you are asked to use dash as the default system shell.): " && read -p "please input y to continue and CTRL +C to quit! : "  SELECT ;
	$(Q)sudo dpkg-reconfigure dash
	$(Q)$(call sj_echo_log, info , " 1. setup the PSDKLA sdk config dash... done!");
	$(Q)$(call sj_echo_log, info , "1. la_install_ubuntu_lib ... done! "); 

la_install_sdk:check_paths_downloads la_install_ubuntu_lib
	$(Q)$(call sj_echo_log, info , "1. la_install_sdk ... "); 
	$(SJ_PATH_JACINTO)/scripts/j7/install_psdkla.sh -s $(SJ_PSDKLA_BRANCH) -i yes -p $(SJ_PATH_PSDKLA)
	$(Q)$(call sj_echo_log, info , "1. la_install_sdk ... done! "); 

la_install_addon_makefile: check_paths_PSDKLA 
	$(Q)$(call sj_echo_log, info , "1. la_install_addon_makefile ... "); 
	$(Q)if [ ! -f $(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak ] ; then \
		ln -s $(SJ_PATH_JACINTO)/makerules/psdkla/makefile_psdkla_addon.mak  $(SJ_PATH_PSDKLA) ; \
		ls -l $(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak; \
		$(ECHO) "please add the makefile_psdkla_addon.mak to $(SJ_PATH_PSDKLA)/Makefile"; \
		sed -i "2c ""-include makefile_psdkla_addon.mak" $(SJ_PATH_PSDKLA)/Makefile;\
		$(ECHO) "done"; \
	else \
		echo "$(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak already installed, continue..."; \
	fi
	$(Q)$(call sj_echo_log, info , "1. la_install_addon_makefile ... done! "); 

la_yocto_install: check_paths_PSDKLA 
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	$(Q)if [ ! -d  $(SJ_PATH_PSDKLA)/yocto-build/sources ] ; then \
		cd $(SJ_PATH_PSDKLA)/yocto-build/      && ./oe-layertool-setup.sh -f configs/processor-sdk-linux/$(SJ_YOCTO_CONFIG_FILE); \
		cd $(SJ_PATH_PSDKLA)/yocto-build/      && . conf/setenv;\
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo 'ARAGO_BRAND = "processor-sdk"' >> conf/local.conf; \
	else \
		echo "# Yocto already installed, continue...  "; \
	fi
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install ... done! "); 

la_yocto_build: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_build ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv && MACHINE=$(SJ_SOC_TYPE)-evm bitbake -k tisdk-default-image
	echo "Finished, congratulations !!!"
	$(Q)$(call sj_echo_log, info , "1. la_yocto_build ... done! "); 

la_yocto_module_clean: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_module_clean MOD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv && MACHINE=$(SJ_SOC_TYPE)-evm bitbake $(MOD)  -c do_cleanall
	$(Q)$(call sj_echo_log, info , "1. la_yocto_module_clean ... done! "); 

la_yocto_module_build: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_module_build MOD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv && MACHINE=$(SJ_SOC_TYPE)-evm bitbake $(MOD)
	$(Q)$(call sj_echo_log, info , "1. la_yocto_module_build ... done! "); 

la_yocto_sources_check: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_source_check CMD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources && $(CMD)
	$(Q)$(call sj_echo_log, info , "1. la_yocto_source_check ... done! "); 


la_yocto_build_check: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_build_check CMD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && $(CMD)
	$(Q)$(call sj_echo_log, info , "1. la_yocto_build_check ... done! "); 


la_yocto_sources_status: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_status CMD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/bitbake/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-arago/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-arm/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-aws/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-openembedded/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-psdkla/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-qt5/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-ti/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-virtualization/ && git status
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/oe-core/ && git status
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_status ... done! "); 

la_yocto_sources_branch: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_branch CMD=? ... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/bitbake/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-arago/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-arm/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-aws/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-openembedded/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-psdkla/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-qt5/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-ti/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/meta-virtualization/ && git branch
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/oe-core/ && git branch
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_branch ... done! "); 

la_yocto_sources_git: check_paths_PSDKLA  
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_git MOD=? CMD=?... "); 
	$(Q)$(call sj_echo_log, file , "--- env","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/setenv"); 
	$(Q)$(call sj_echo_log, file , "--- local conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/local.conf"); 
	$(Q)$(call sj_echo_log, file , "--- layer conf","$(SJ_PATH_PSDKLA)/yocto-build/build/conf/bblayers.conf"); 
	$(Q)$(call sj_echo_log, info , "MOD: bitbake  meta-arago  meta-arm  meta-aws  meta-openembedded  meta-psdkla  meta-qt5  meta-ti  meta-virtualization  oe-core"); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/sources/$(MOD) && $(CMD)
	$(Q)$(call sj_echo_log, info , "1. la_yocto_sources_git ... done! "); 


##########################################
# sd install                             #
##########################################
la_sd_mk_partition:
	$(Q)$(call sj_echo_log, info , "1. la_sd_mk_partition ... "); 
	if [ $(SJ_ENABLE_UI) = "YES" ]; then \
		echo "[ `date` ] >>> UI  :  la-sd-mk-partition"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkla-ui.sh; \
	else \
		sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkla.sh; \
	fi
	$(Q)$(call sj_echo_log, info , "1. la_sd_mk_partition ... done! "); 
	

la_sd_install_all:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_all ... "); 
	@echo ">>> starting make SD for PSDKLA"
	$(SJ_PATH_SCRIPTS)/mk_sd_psdkla.sh $(SJ_BOOT1) $(SJ_ROOTFS) 
	@echo "please unplug the sd card."
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_all ... done! "); 


la_sd_install_rootfs:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_rootfs ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. start to install bootfs ... ");
	cd $(SJ_PATH_PSDKLA) && tar -zxvf $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/boot-adas-$(SJ_SOC_TYPE)-evm.tar.gz -C $(SJ_BOOT1)
	$(Q)$(call sj_echo_log, info , " --- 1. start to install bootfs ... done!!!");
	$(Q)$(call sj_echo_log, info , " --- 1. start to install rootfs ... ");
	cd $(SJ_PATH_PSDKLA) && sudo tar -xvf $(SJ_PATH_PSDKLA)/filesystem/tisdk-adas-image-$(SJ_SOC_TYPE)-evm.tar.xz -C $(SJ_ROOTFS)
	$(Q)$(call sj_echo_log, info , " --- 1. start to install rootfs ... done!!!");
	$(Q)$(call sj_echo_log, info , " --- please unplug the sd card... ");
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_rootfs ... done! "); 


la_sd_am62x_install_all: check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	$(Q)$(call sj_echo_log, info , "1. la_sd_am62x_install_all ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. install am62x rootfs to sdcard... ");
	sudo $(SJ_PATH_PSDKLA)/bin/create-sdcard.sh
	# sudo cp $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3-am62x-hs-evm.bin $(SJ_BOOT1)/tiboot3.bin
	$(Q)$(call sj_echo_log, info , " --- 1. install am62x rootfs to sdcard... done!!!");
	$(Q)$(call sj_echo_log, info , "1. la_sd_am62x_install_all ... done! "); 

la_dfu_boot_am62x:
	$(Q)$(call sj_echo_log, info , "1. la_dfu_boot_am62x ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. install am62x rootfs to sdcard... ");
	# sudo $(SJ_PATH_PSDKLA)/bin/DFU_flash/u-boot_flashwriter.sh emmc am62x
	sudo dfu-util -R -a bootloader -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin
	sudo dfu-util -l
	sudo dfu-util -R -a tispl.bin  -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/tispl.bin
	sudo dfu-util -R -a u-boot.img -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/u-boot.img
	$(Q)$(call sj_echo_log, info , " --- 1. install am62x rootfs to sdcard... done!!!");
	$(Q)$(call sj_echo_log, info , "1. la_dfu_boot_am62x ... done! "); 


la_sd_install_scripts:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_scripts ... "); 
	@echo ">>> install the mksdboot.sh to SD /home/root"
	@echo " test path: $(SJ_ROOTFS) "
	@if [ ! -d $(SJ_ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	$(Q)sudo ls -l $(SJ_ROOTFS)/home/root
	$(Q)sudo install $(SJ_PATH_PSDKLA)/bin/mksdboot.sh $(SJ_ROOTFS)/home/root
	$(Q)sudo install $(SJ_PATH_SCRIPTS)/j7/ub960_pattern_start.sh $(SJ_ROOTFS)/home/root
	$(Q)sudo install $(SJ_PATH_SCRIPTS)/j7/yavta_catch_camera.sh $(SJ_ROOTFS)/home/root
	$(Q)sudo ls -l $(SJ_ROOTFS)/home/root
	@echo "done. please unplug the sd card."
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_scripts ... done! "); 

la_sd_setup_j7_fredy_tools:
	$(Q)$(call sj_echo_log, info , "1. la_sd_setup_j7_fredy_tools ... "); 
	scp -r $(SJ_PATH_SCRIPTS)/j7/*  root@$(SJ_EVM_IP):/home/root
	echo "done"
	$(Q)$(call sj_echo_log, info , "1. la_sd_setup_j7_fredy_tools ... done! "); 


#~ la-sd-mounnt: check_paths_PSDKLA 
#~ 	sudo mount /dev/sda1 /media/fredy/boot 
#~ 	sudo mount /dev/sda2 /media/fredy/rootfs
#~ la-sd-unmounnt: check_paths_PSDKLA 
#~ 	sudo umount /dev/sda1 /media/fredy/boot 
#~ 	sudo umount /dev/sda2 /media/fredy/rootfs
# setup nfs. 
la_setup_env_nfs: 
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_nfs ... "); 
	cd $(SJ_PATH_PSDKLA) && ./setup.sh
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_nfs ... done! "); 
	
la_setup_env_minicom:
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_minicom ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the minicom port ... ");
	$(Q)$(SJ_PATH_SCRIPTS)/setup-minicom.sh
	$(Q)$(call sj_echo_log, info , " --- 1. setup the minicom port ... done!");
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_minicom ... done! "); 

la_setup_env_minicom_all:
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_minicom_all ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup all the  minicom port ... ");
	# this command will open all the UART terminal.
	$(SJ_PATH_SCRIPTS)/setup-minicom-all.sh
	# open done
	$(Q)$(call sj_echo_log, info , " --- 1. setup all the  minicom port ... done!");
	$(Q)$(call sj_echo_log, info , "1. la_setup_env_minicom_all ... done! "); 

la_open_uart_terminal: la-setup-env-minicom
	$(Q)$(call sj_echo_log, info , "1. la_open_uart_terminal ... "); 
	minicom
	$(Q)$(call sj_echo_log, info , "1. la_open_uart_terminal ... done! "); 

la_help_install:
	$(Q)$(call sj_echo_log, info , "1. la_install_help ... "); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "la_install_ubuntu_lib","update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_install_sdk", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_install_addon_makefile", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_install", "install the yocto ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_build  ", "build the yocto ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_build_check", " check the build ditionary content ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_module_clean", "yocto module clean ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_module_build", "yocto module build ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_sources_status", "check yocoto sources git status... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_sources_check", " check the yocto sources content ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_sources_git", " MOD=? CMD=?  ... "); 
	$(Q)$(call sj_echo_log, help , "la_yocto_sources_branch", "check the yocto sources git branch ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_mk_partition", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_install_all", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_install_rootfs", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_am62x_install_all", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_dfu_boot_am62x", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_install_scripts", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_sd_setup_j7_fredy_tools", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_setup_env_nfs", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_setup_env_minicom", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_setup_env_minicom_all", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "la_open_uart_terminal", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. la_install_help ... done! "); 
