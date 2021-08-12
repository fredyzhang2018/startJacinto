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
	echo "install $(PSDKLA_PATH)"
	echo "1. downlaod the SDK"
	$(Q)if [ ! -d $(PSDKLA_PATH) ] ; then \
		if [ ! -f $(DOWNLOADS_PATH)/`echo $(PSDKLA_SDK_URL) | cut -d / -f 9` ] ; then \
			cd $(DOWNLOADS_PATH) && wget $(PSDKLA_SDK_URL); \
		fi; \
		echo "2. run setup scripts"; \
		cd $(DOWNLOADS_PATH) && chmod a+x ./ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin; \
		echo "please set your install PATH: $(PSDKLA_PATH) " && read -p "please input y to continue and CTRL +C to quit! : "  SELECT ;\
		cd $(DOWNLOADS_PATH) && ./ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin; \
		echo "please run the setup scripts " ; \
		cd $(PSDKLA_PATH) &&  ./setup.sh
	else \
		echo "sdk already installed, continue..."; \
	fi


la-install-addon-makefile: check_paths_PSDKLA 
	ln -s $(jacinto_PATH)/makerules/psdkla/makefile_psdkla_addon.mak  $(PSDKLA_PATH)/
	ls -l $(PSDKLA_PATH)/makefile_psdkla_addon.mak
	$(Q)$(ECHO) "please add the makefile_psdkla_addon.mak to $(PSDKLA_PATH)/Makefile"
	$(Q)$(ECHO) "done"
##########################################
# sd install                             #
##########################################
la-sd-mk-partition:
	sudo $(SCRIPTS_PATH)/mk-linux-card-psdkla.sh

la-sd-install-all:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	@echo ">>> starting make SD for PSDKLA"
	$(SCRIPTS_PATH)/mk_sd_psdkla.sh $(BOOT1) $(ROOTFS) 
	@echo "please unplug the sd card."

la-sd-install-mksdboot-scripts:  check_paths_PSDKLA check_paths_sd_boot1 check_paths_sd_rootfs 
	@echo ">>> install the mksdboot.sh to SD /home/root"
	@echo " test path: $(ROOTFS) "
	@if [ ! -d $(ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	sudo install $(PSDKLA_PATH)/bin/mksdboot.sh $(ROOTFS)/home/root
	@echo "done. please unplug the sd card."

la-sd-setup-j7-fredy-tools:
	scp -r $(SCRIPTS_PATH)/j7/*  root@10.85.130.220:/home/root
	echo "done"
	
#~ la-sd-mounnt: check_paths_PSDKLA 
#~ 	sudo mount /dev/sda1 /media/fredy/boot 
#~ 	sudo mount /dev/sda2 /media/fredy/rootfs
#~ la-sd-unmounnt: check_paths_PSDKLA 
#~ 	sudo umount /dev/sda1 /media/fredy/boot 
#~ 	sudo umount /dev/sda2 /media/fredy/rootfs
# setup nfs. 
la-setup-env-nfs: 
	cd $(PSDKLA_PATH) && ./setup.sh
	
la-setup-env-minicom:
	$(SCRIPTS_PATH)/setup-minicom.sh

la-setup-env-addon-makefile:
	cd $(PSDKLA_PATH) && ln -s $(jacinto_PATH)/makerules/psdkla/makefile_psdkla_addon.mak $(PSDKLA_PATH)/
	$(Q)echo "install done!"



##########################################
# Yocto                                 #
##########################################
