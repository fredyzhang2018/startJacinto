########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries    
#                                                      #
########################################################

la-install-ubuntu-lib:
	# sudo apt-get install build-essential autoconf automake bison flex libssl-dev bc u-boot-tools python diffstat texinfo gawk chrpath dos2unix wget unzip socat doxygen libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386 g++-multilib
	echo "Congure your ENV Dash (Be sure to select “No” when you are asked to use dash as the default system shell.): " && read -p "please input y to continue and CTRL +C to quit! : "  SELECT ;
	sudo dpkg-reconfigure dash
	echo "configure done !!!"


la-install-sdk:check_paths_downloads la-install-ubuntu-lib
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the PSDKLA sdk");
	./scripts/j7/install_psdkla.sh -s $(SJ_PSDKLA_BRANCH) -i yes -p $(SJ_PATH_PSDKLA)
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the PSDKLA sdk --done");

la-install-addon-makefile: check_paths_PSDKLA 
	$(Q)if [ ! -f $(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak ] ; then \
		ln -s $(SJ_PATH_JACINTO)/makerules/psdkla/makefile_psdkla_addon.mak  $(SJ_PATH_PSDKLA) ; \
		ls -l $(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak; \
		$(ECHO) "please add the makefile_psdkla_addon.mak to $(SJ_PATH_PSDKLA)/Makefile"; \
		sed -i "2c ""-include makefile_psdkla_addon.mak" $(SJ_PATH_PSDKLA)/Makefile;\
		$(ECHO) "done"; \
	else \
		echo "$(SJ_PATH_PSDKLA)/makefile_psdkla_addon.mak already installed, continue..."; \
	fi


la-yocto-install: check_paths_PSDKLA 
	$(Q)if [ ! -d  $(SJ_PATH_PSDKLA)/yocto-build/sources ] ; then \
		cd $(SJ_PATH_PSDKLA)/yocto-build/      && ./oe-layertool-setup.sh -f configs/processor-sdk-linux/$(SJ_YOCTO_CONFIG_FILE); \
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo "INHERIT += \"own-mirrors\"" >> conf/local.conf; \
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo "SOURCE_MIRROR_URL = \"http://software-dl.ti.com/processor-sdk-mirror/sources/\"" >> conf/local.conf ;\
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo "ARAGO_BRAND  = \"psdkla\"" >> conf/local.conf ;\
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo "DISTRO_FEATURES_append = \" virtualization\"" >> conf/local.conf ;\
		cd $(SJ_PATH_PSDKLA)/yocto-build/build && echo "IMAGE_INSTALL_append = \" docker\"">> conf/local.conf ;\
	else \
		echo "# Yocto already installed, continue...  "; \
	fi

la-yocto-build: check_paths_PSDKLA check_paths_PSDKLA 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv && TOOLCHAIN_BASE=$(SJ_PATH_PSDKRA) MACHINE=j7-evm bitbake -k tisdk-default-image
	echo "Finished, congratulations !!!"

##########################################
# sd install                             #
##########################################
la-sd-mk-partition:
	if [ $(SJ_ENABLE_UI) = "YES" ]; then \
		echo "[ `date` ] >>> UI  :  la-sd-mk-partition"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkla-ui.sh; \
	else \
		sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkla.sh; \
	fi
	

la-sd-install-all:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	@echo ">>> starting make SD for PSDKLA"
	$(SJ_PATH_SCRIPTS)/mk_sd_psdkla.sh $(SJ_BOOT1) $(SJ_ROOTFS) 
	@echo "please unplug the sd card."


la-sd-am62x-install-all: check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	$(Q)$(call sj_echo_log, 0 , " --- 1. install am62x rootfs to sdcard... ");
	sudo $(SJ_PATH_PSDKLA)/bin/create-sdcard.sh
	# sudo cp $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3-am62x-hs-evm.bin $(SJ_BOOT1)/tiboot3.bin
	$(Q)$(call sj_echo_log, 0 , " --- 1. install am62x rootfs to sdcard... done!!!");

la-dfu-boot-am62x:
	$(Q)$(call sj_echo_log, 0 , " --- 1. install am62x rootfs to sdcard... ");
	# sudo $(SJ_PATH_PSDKLA)/bin/DFU_flash/u-boot_flashwriter.sh emmc am62x
	sudo dfu-util -R -a bootloader -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin
	sudo dfu-util -l
	sudo dfu-util -R -a tispl.bin  -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/tispl.bin
	sudo dfu-util -R -a u-boot.img -D $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/u-boot.img
	$(Q)$(call sj_echo_log, 0 , " --- 1. install am62x rootfs to sdcard... done!!!");


la-sd-install-scripts:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
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

la-sd-setup-j7-fredy-tools:
	scp -r $(SJ_PATH_SCRIPTS)/j7/*  root@$(SJ_EVM_IP):/home/root
	echo "done"

la-psdkla-0702-csi-ub960-demo: check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs  
	$(Q)echo "# 0. reset the default sdks"
	#cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && git reset --hard
	$(Q)echo "# 1. apply the patches"
	#cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && git am --signoff $(SJ_PATH_RESOURCE)/psdkla/CSI-0702-patch/00*
	$(Q)echo "# 2. build the sdk"
	cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && ./ti_config_fragments/defconfig_builder.sh -t ti_sdk_arm64_release 
	cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && make ARCH=arm64 ti_sdk_arm64_release_defconfig
	cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && make ARCH=arm64 CROSS_COMPILE=$(SJ_PATH_PSDKLA)/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/aarch64-none-linux-gnu-  Image
	cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && make ARCH=arm64 CROSS_COMPILE=$(SJ_PATH_PSDKLA)/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/aarch64-none-linux-gnu-  modules
	cd $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a && make ARCH=arm64 CROSS_COMPILE=$(SJ_PATH_PSDKLA)/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/aarch64-none-linux-gnu-  dtbs
	#$(Q)echo "# 3. update the sd card"
	make la-sd-linux-install 
	sudo install $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a/arch/arm64/boot/Image $(SJ_ROOTFS)/boot
	sudo install $(SJ_PATH_PSDKLA)/board-support/linux-5.4.74+gitAUTOINC+9574bba32a-g9574bba32a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb $(SJ_ROOTFS)/boot
	make la-sd-install-scripts
	$(Q)echo "setup done, please insert to board, and restart the system. "

#~ la-sd-mounnt: check_paths_PSDKLA 
#~ 	sudo mount /dev/sda1 /media/fredy/boot 
#~ 	sudo mount /dev/sda2 /media/fredy/rootfs
#~ la-sd-unmounnt: check_paths_PSDKLA 
#~ 	sudo umount /dev/sda1 /media/fredy/boot 
#~ 	sudo umount /dev/sda2 /media/fredy/rootfs
# setup nfs. 
la-setup-env-nfs: 
	cd $(SJ_PATH_PSDKLA) && ./setup.sh
	
la-setup-env-minicom:
	$(SJ_PATH_SCRIPTS)/setup-minicom.sh

la-setup-env-minicom-all:
	# this command will open all the UART terminal.
	$(SJ_PATH_SCRIPTS)/setup-minicom-all.sh
	# open done

la-open-uart-terminal: la-setup-env-minicom
	minicom

la-install-help:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "Available build targets are  :"
	$(Q)$(ECHO) "    ----------------Install --------------------------------------  "
	$(Q)$(ECHO) "    la-install-ubuntu-lib        : ubuntu dependent lib;    "
	$(Q)$(ECHO) "    la-install-sdk               : Install SDK;   "
	$(Q)$(ECHO) "    la-install-addon-makefile    : additial makefile; "
	$(Q)$(ECHO) "    -------------------Yocto--------------------------------------  "
	$(Q)$(ECHO) "    la-yocto-install             : install yocto env;  "
	$(Q)$(ECHO) "    la-yocto-build               : build the yocto;"
	$(Q)$(ECHO) "    -------------------SD --------------------------------------  "
	$(Q)$(ECHO) "    la-sd-mk-partition       "
	$(Q)$(ECHO) "    la-sd-install-all        "
	$(Q)$(ECHO) "    la-sd-mk-partition       "
	$(Q)$(ECHO) "    la-sd-install-scripts       "
	$(Q)$(ECHO) "    -------------------SD --------------------------------------  "
	$(Q)$(ECHO) "    la-setup-env-nfs       "
	$(Q)$(ECHO) "    la-setup-env-minicom      "
	$(Q)$(ECHO) "    -------------------Demo --------------------------------------  "
	$(Q)$(ECHO) "    la-psdkla-0702-csi-ub960-demo   # 0703 will not work with 0702"
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "