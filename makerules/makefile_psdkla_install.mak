########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries    
#                                                      #
########################################################

la-install-ubuntu-lib:
	sudo apt-get install build-essential autoconf automake bison flex libssl-dev bc u-boot-tools python diffstat texinfo gawk chrpath dos2unix wget unzip socat doxygen libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386 g++-multilib
	echo "Congure your ENV Dash (Be sure to select “No” when you are asked to use dash as the default system shell.): " && read -p "please input y to continue and CTRL +C to quit! : "  SELECT ;
	sudo dpkg-reconfigure dash
	echo "configure done !!!"

la-install-sdk: check_paths_downloads la-install-ubuntu-lib
	echo "install $(SJ_PATH_PSDKLA)"
	echo "1. downlaod the SDK"
	$(Q)if [ ! -d $(SJ_PATH_PSDKLA) ] ; then \
		if [ ! -f $(SJ_PATH_DOWNLOAD)/`echo $(SJ_PSDKLA_SDK_URL) | cut -d / -f 9` ] ; then \
			cd $(SJ_PATH_DOWNLOAD) && wget $(SJ_PSDKLA_SDK_URL); \
		fi; \
		echo "2. run setup scripts"; \
		cd $(SJ_PATH_DOWNLOAD) && chmod a+x ./`echo $(SJ_PSDKLA_SDK_URL) | cut -d / -f 9`; \
		echo "please set your install PATH: $(SJ_PATH_PSDKLA) " && read -p "please input y to continue and CTRL +C to quit! : "  SELECT ;\
		cd $(SJ_PATH_DOWNLOAD) && ./`echo $(SJ_PSDKLA_SDK_URL) | cut -d / -f 9`; \
		echo "please run the setup scripts " ; \
		cd $(SJ_PATH_PSDKLA) &&  ./setup.sh; \
		echo "please run: make la-install-addon-makefile to support update image to SD card:" ;\
	else \
		echo "sdk already installed, continue..."; \
	fi

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
	sudo $(SJ_PATH_SCRIPTS)/mk-linux-card-psdkla.sh

la-sd-install-all:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	@echo ">>> starting make SD for PSDKLA"
	$(SJ_PATH_SCRIPTS)/mk_sd_psdkla.sh $(SJ_BOOT1) $(SJ_ROOTFS) 
	@echo "please unplug the sd card."

la-sd-install-mksdboot-scripts:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	@echo ">>> install the mksdboot.sh to SD /home/root"
	@echo " test path: $(SJ_ROOTFS) "
	@if [ ! -d $(SJ_ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	sudo install $(SJ_PATH_PSDKLA)/bin/mksdboot.sh $(SJ_ROOTFS)/home/root
	@echo "done. please unplug the sd card."

la-sd-setup-j7-fredy-tools:
	scp -r $(SJ_PATH_SCRIPTS)/j7/*  root@10.85.130.220:/home/root
	echo "done"
	
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




psdkla-install-help:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "Available build targets are  :"
	$(Q)$(ECHO) "    ----------------Build --------------------------------------  "
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
	$(Q)$(ECHO) "    la-sd-install-mksdboot-scripts       "
	$(Q)$(ECHO) "    -------------------SD --------------------------------------  "
	$(Q)$(ECHO) "    la-setup-env-nfs       "
	$(Q)$(ECHO) "    la-setup-env-minicom      "
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "