########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################
la-install_0601:
	echo "install PSDKLA 0601"
	mkdir -p ./temp_0601
	echo "1. downlaod the SDK"
	cd ./temp_0601/ && wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/06_01_00_05/exports/ti-processor-sdk-linux-automotive-j7-evm-06_01_00_05-Linux-x86-Install.bin
	echo "2. run sdk setup scripts"
	cd $(PSDKLA_PATH) && ./sdk-install.sh
	echo "3. run the setup environment"
	cd $(PSDKLA_PATH) && ./setup.sh
	echo "setup done"

la-install_0602:
	echo "install PSDKLA 0602"
	mkdir -p ./temp_0602
	echo "1. downlaod the SDK"
	cd ./temp_0700/ && wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/06_02_00_07/exports/ti-processor-sdk-linux-automotive-j7-evm-06_02_00-Linux-x86-Install.bin
	echo "2. run setup scripts"

la-install_07_02_00_07: check_paths_downloads
	echo "install PSDKLA 07 02 00 07"
	echo "1. downlaod the SDK"
	cd $(DOWNLOADS_PATH) && wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_02_00_07/exports/ti-processor-sdk-linux-j7-evm-07_02_00_07-Linux-x86-Install.bin
	echo "2. run setup scripts"
	cd $(DOWNLOADS_PATH) && chmod a+x ./ti-processor-sdk-linux-j7-evm-07_02_00_07-Linux-x86-Install.bin 
	cd $(DOWNLOADS_PATH) && ./ti-processor-sdk-linux-j7-evm-07_02_00_07-Linux-x86-Install.bin
	echo "please run the setup scripts "

la-install_07_03_00_05: check_paths_downloads
	echo "install PSDKLA 07 03 00 05"
	echo "1. downlaod the SDK"
	cd $(DOWNLOADS_PATH) && wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/07_03_00_05/exports/ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
	echo "2. run setup scripts"
	cd $(DOWNLOADS_PATH) && chmod a+x ./ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
	cd $(DOWNLOADS_PATH) && ./ti-processor-sdk-linux-j7-evm-07_03_00_05-Linux-x86-Install.bin
	echo "please run the setup scripts "

la-install_0700:
	echo "install PSDKLA 0700"
	mkdir -p ./temp_0700
	echo "1. downlaod the SDK"
	cd ./temp_0700/ && wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/latest/exports/ti-processor-sdk-linux-automotive-j7-evm-07_00_01-Linux-x86-Install.bin
	echo "2. run setup scripts"

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
