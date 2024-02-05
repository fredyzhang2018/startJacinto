########################################################
#                                                      #
#  Edit this file to suit your specific build needs    #
#  Utility makefile to build Vison SDK libraries       #
#                                                      #
########################################################

##########################################
#                                        #
# atf                                    #
#                                        #
##########################################
#~ la-k3-atf:
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  atf 
#~ la-k3-atf_clean:
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  atf-clean
#~ la-k3-atf_install:
#~ 	echo "add later"
##########################################
#                                        #
# optee                                    #
#                                        #
##########################################
#~ la-k3-optee:     
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  optee 
#~ la-k3-optee-clean:
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  optee-clean
#~ la-k3-optee_install:
#~ 	echo "add later"
##########################################
#                                        #
# optee                                  #
#                                        #
##########################################	
#~ la-uboot:     
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  u-boot
#~ la-uboot-clean:
#~ 	cd $(KS3_LINUX_INTEGRATED) && $(MAKE)  u-boot-clean
#~ la-uboot-install:
#~ 	install $(KS3_LINUX_INTEGRATED)/build/tispl.bin $(BOOT)	
#~ 	install $(KS3_LINUX_INTEGRATED)/build/tiboot3.bin $(BOOT)	
#~ 	install $(KS3_LINUX_INTEGRATED)/build/u-boot.img $(BOOT)	
#~ 	sync
#~ la-uboot-install_tispl:
#~ 	install $(KS3_LINUX_INTEGRATED)/build/tispl.bin $(BOOT)	
#~ 	install $(KS3_LINUX_INTEGRATED)/build/tiboot3.bin $(BOOT)	
#~ 	install $(KS3_LINUX_INTEGRATED)/build/u-boot.img $(BOOT)	
#~ 	sync
#~ la-uboot-install_tiboot3:
#~ 	install $(KS3_LINUX_INTEGRATED)/build/u-boot.img $(BOOT)	
#~ 	sync
#~ la-uboot-install_uboot-img:
#~ 	install $(KS3_LINUX_INTEGRATED)/build/u-boot.img $(BOOT)	
#~ 	sync

##########################################
#                                        #
# uboot                                  #
#                                        #
##########################################	
la-uboot:     
	cd $(SJ_PATH_PSDKLA) && $(MAKE)  u-boot
la-uboot-clean:
	cd $(SJ_PATH_PSDKLA) && $(MAKE)  u-boot_clean
la-sd-install-uboot:
ifeq ($(SJ_VER_SDK),09)
	$(Q)if [ ! -d $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_UBOOT)/build/r5/tiboot3.bin  $(SJ_BOOT1); \
		install $(SJ_PATH_UBOOT)/build/a72/tispl.bin   $(SJ_BOOT1); \
		install $(SJ_PATH_UBOOT)/build/a72/u-boot.img  $(SJ_BOOT1); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	else \
		install $(SJ_PATH_UBOOT)/build/r5/tiboot3.bin  $(SJ_BOOT); \
		install $(SJ_PATH_UBOOT)/build/a72/tispl.bin   $(SJ_BOOT); \
		install $(SJ_PATH_UBOOT)/build/a72/u-boot.img  $(SJ_BOOT); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	fi 
else
	$(Q)if [ ! -d $(SJ_BOOT) ] ; then \
		echo "hello world "; \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin  $(SJ_BOOT1); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT1); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT1); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin  $(SJ_BOOT); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	fi 
	sync
endif
	
la-sd-install-uboot-a53:
	$(Q)if [ ! -d $(SJ_BOOT) ] ; then \
		echo "hello world "; \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/tispl.bin  $(SJ_BOOT1); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT1); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/u-boot.img $(SJ_BOOT1); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/tispl.bin  $(SJ_BOOT); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT); \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a53/u-boot.img $(SJ_BOOT); \
		echo "new world: update the tispl.bin tiboot3.bin u-boot.img"; \
	fi 
	sync
	
la-sd-install-uboot-tispl:
	@if [ ! $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin $(SJ_BOOT1); \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin $(SJ_BOOT); \
	fi
	sync
la-sd-install-uboot-tiboot3:
	@if [ -d $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT)	; \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT1)	; \
	fi
	sync

la-sd-install-uboot-uboot-img:
	@if [ ! $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT1); \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT); \
	fi
	sync
	
##########################################
#                                        #
# sysfw-image                            #
#                                        #
##########################################
la-sysfw-image:
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image -j$(CPU_NUM)
la-sysfw-image_clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image_clean -j$(CPU_NUM)	
la-sysfw-image_install:
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image_install -j$(CPU_NUM)	

##########################################
#                                        #
# linux                                  #
#                                        #
##########################################
la-linux:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux -j$(CPU_NUM)
la-linux-clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux_clean -j$(CPU_NUM)	
la-linux-install:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux_install -j$(CPU_NUM)	
la-sd-linux-install:
	sudo $(MAKE) -C $(SJ_PATH_PSDKLA) linux_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)
	sync
##########################################
#                                        #
# linux dtb                              #
#                                        #
##########################################
la-linux-dtbs:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs -j$(CPU_NUM)
la-linux-dtbs-clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_clean -j$(CPU_NUM)	
la-linux-dtbs-install:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_install -j$(CPU_NUM)		
la-sd-install-linux-dtbs:
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)
	ls -l $(SJ_ROOTFS)/boot/dtb/ti/

##########################################
#                                        #
# GPU build                              #
#                                        #
##########################################
la-gpu:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver -j$(CPU_NUM)
la-gpu-clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_clean -j$(CPU_NUM)	
la-gpu-install:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install -j$(CPU_NUM)		
la-gpu-install-sd:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)

la-gpu-install-nfs-psdkla:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_PATH_PSDKLA)/targetNFS/ -j$(CPU_NUM)

la-gpu-install-nfs-psdkra:
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_PATH_PSDKRA)/targetfs/ -j$(CPU_NUM)


##########################################
#                                        #
# uboot-r5                               #
#                                        #
##########################################
la-u-boot-r5:
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-r5 -j$(CPU_NUM)
la-u-boot-r5_clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-r5_clean -j$(CPU_NUM)	


##########################################
#                                        #
# uboot-a72                               #
#                                        #
##########################################
la-u-boot-a72:
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-a72 -j$(CPU_NUM)
la-u-boot-a72-clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-a72_clean -j$(CPU_NUM)	


##########################################
#                                        #
# remote run                               #
#                                        #
##########################################
la-remote-run-command: la-update-remote-image
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- done !!!");

la-update-remote-image: 
	$(Q)$(call sj_echo_log, 0 , " 0. update the iamge:$(SJ_PATH_PSDKRA)/$(SJ_TIDL_TYPE)/vision_apps/out/J7/A72/LINUX/release/vx_app_srv_fileio.out ---- start !!!");
	scp $(SJ_PATH_PSDKRA)/$(SJ_TIDL_TYPE)/vision_apps/out/J7/A72/LINUX/release/vx_app_srv_fileio.out   root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(call sj_echo_log, 0 , " 0. update the iamge:$(SJ_PATH_PSDKRA)/$(SJ_TIDL_TYPE)/vision_apps/out/J7/A72/LINUX/release/vx_app_srv_fileio.out ---- Done !!!");


la-remote-run-ssh:
	$(Q)$(call sj_echo_log, 0 , " 0. Run the remote ssh -------------------------------- start !!!");
	ssh  root@$(SJ_EVM_IP) 
	

la-hs-uboot:
	cd $(SJ_PATH_JACINTO)/sdks && git clone git://git.ti.com/security-development-tools/core-secdev-k3.git
	export TI_SECURE_DEV_PKG=$(SJ_PATH_JACINTO)/sdks/core-secdev-k3 && \
	


##########################################
#                                        #
# jailhouse                              #
#                                        #
##########################################	
la-jailhouse:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse -j$(CPU_NUM)
la-jailhouse_clean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_clean -j$(CPU_NUM)	
la-jailhouse_config:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_config -j$(CPU_NUM)	
la-jailhouse_install:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_install -j$(CPU_NUM)	
la-jailhouse_install_sd:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_install_sd -j$(CPU_NUM)	
la-jailhouse_distclean:
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_distclean -j$(CPU_NUM)	
#==============================================================================
# install the staus. 
#==============================================================================	
la-install_yoctolayer:	
	cd $(SJ_PATH_PSDKLA)/yocto-build && ./oe-layertool-setup.sh -f $(SJ_PATH_PSDKLA)/yocto-build/configs/psdkla/la-06_00_01_00.txt

la-install_yocto_env:
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv
	@echo "please use below command to compile"
	@echo "TOOLCHAIN_BASE=/home/fredy/j7/psdk_rtos_auto_j7_06_00_00_00/ MACHINE=j7-evm bitbake -k tisdk-rootfs-image"
	
#==============================================================================
# QT the staus. 
#==============================================================================	
la-qt-showimage-build:
	$(Q)$(call sj_echo_log, 0 , " --- 1. build the QT show image: $(SJ_PATH_SDK)/QT/showImage ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/QT/showImage && ./makeImgShow
	$(Q)$(call sj_echo_log, 0 , " --- 1. build the QT show image: $(SJ_PATH_SDK)/QT/showImage --done!!! ");	

#==============================================================================
# A help message target.
#==============================================================================
la_help:
	@echo
	@echo "SJ_PATH_PSDKRA : $(SJ_PATH_PSDKRA)"
	@echo "SJ_PATH_PSDKLA : $(SJ_PATH_PSDKLA)"
	@echo "SJ_BOOT   : $(SJ_BOOT)"
	@echo "SJ_ROOTFS : $(SJ_ROOTFS)"
	@echo "Available build targets are  :"
	@echo            
	@echo "    sysfw-image                    : Build sysfw-image"
	@echo "    sysfw-image_clean              : clean sysfw-image"
	@echo "    sysfw-image_install            : sysfw-image_install"
	@echo 
	@echo "    u-boot-r5                      :  "
	@echo "    u-boot-r5_clean                :  "
	@echo "    u-boot-r5_install              :  "
	@echo
	@echo "    linux                          :  "
	@echo "    linux_clean                    :  "
	@echo "    linux_install                  :  " 
	@echo "    linux_install_sd_rootfs        : install linux kernel and module to sd rootfs" 
	@echo
	@echo "    linux-dtbs                     :  "
	@echo "    linux-dtbs_clean               :  "
	@echo "    linux-dtbs_install             :  " 
	@echo "    linux-dtbs_SD_install          :  install dtb to sd rootfs/boot"
	@echo
	@echo "    install                        : install all the image to filesystem"
	@echo "    install_FS_TO_SD               : Install format the sd and install, please check sd path"
	@echo "    install_yoctolayer             : Install the yoctor layer"
	@echo "    install_yocto_env              : Install the yoctor environment"
	@echo "    --------  end ---------$(VSDK_DIR)"
	@echo
	


.PHONY: 
