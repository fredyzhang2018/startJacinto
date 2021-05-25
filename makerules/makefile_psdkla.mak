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
	cd $(PSDKLA_PATH) && $(MAKE)  u-boot
la-uboot-clean:
	cd $(PSDKLA_PATH) && $(MAKE)  u-boot-clean
la-uboot-install:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/tispl.bin  $(BOOT1)	
	install $(PSDKLA_PATH)/board-support/u-boot_build/r5/tiboot3.bin $(BOOT1)
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/u-boot.img $(BOOT1)	
	sync
la-uboot-install_tispl:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/tispl.bin $(BOOT1)
	sync
la-uboot-install_tiboot3:
	install $(PSDKLA_PATH)/board-support/u-boot_build/r5/tiboot3.bin $(BOOT1)	
	sync
la-uboot-install_uboot-img:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/u-boot.img $(BOOT1)	
	sync
	
la-uboot-rainstall:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/tispl.bin  $(BOOT)	
	install $(PSDKLA_PATH)/board-support/u-boot_build/r5/tiboot3.bin $(BOOT)
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/u-boot.img $(BOOT)	
	sync
la-uboot-install_ratispl:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/tispl.bin $(BOOT)
	sync
la-uboot-install_ratiboot3:
	install $(PSDKLA_PATH)/board-support/u-boot_build/r5/tiboot3.bin $(BOOT)	
	sync
la-uboot-install_rauboot-img:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a72/u-boot.img $(BOOT)	
	sync
##########################################
#                                        #
# sysfw-image                            #
#                                        #
##########################################
la-sysfw-image:
	$(MAKE) -C $(PSDKLA_PATH) sysfw-image -j$(CPU_NUM)
la-sysfw-image_clean:
	$(MAKE) -C $(PSDKLA_PATH) sysfw-image_clean -j$(CPU_NUM)	
la-sysfw-image_install:
	$(MAKE) -C $(PSDKLA_PATH) sysfw-image_install -j$(CPU_NUM)	
##########################################
#                                        #
# uboot-a72  r5                          #
#                                        #
##########################################
la-u-boot-a53:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-a53 -j$(CPU_NUM)
la-u-boot-a53_clean:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-a53_clean -j$(CPU_NUM)	
la-u-boot-a53_install:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-a53_install -j$(CPU_NUM)	
la-u-boot-a53_install_sd:
	install $(PSDKLA_PATH)/board-support/u-boot_build/a53/tispl.bin $(BOOT)
	install $(PSDKLA_PATH)/board-support/u-boot_build/a53/u-boot.img $(BOOT)
la-u-boot-install: 
	install $(PSDKLA_PATH)/board-support/u-boot_build/a53/tispl.bin $(BOOT)
	install $(PSDKLA_PATH)/board-support/u-boot_build/a53/u-boot.img $(BOOT)
	install $(PSDKLA_PATH)/board-support/u-boot_build/r5/tiboot3.bin $(BOOT)
##########################################
#                                        #
# linux                                  #
#                                        #
##########################################
la-linux:
	$(MAKE) -C $(PSDKLA_PATH) linux -j$(CPU_NUM)
la-linux-clean:
	$(MAKE) -C $(PSDKLA_PATH) linux_clean -j$(CPU_NUM)	
la-linux-install:
	$(MAKE) -C $(PSDKLA_PATH) linux_install -j$(CPU_NUM)	
la-sd-linux-install:
	$(MAKE) -C $(PSDKLA_PATH) linux_install_sd -j$(CPU_NUM)
	sync
	#$(MAKE) -C $(PSDKLA_PATH) linux_install_sd_rootfs DESTDIR=/media/fredy/rootfs -j$(CPU_NUM)		
##########################################
#                                        #
# linux dtb                              #
#                                        #
##########################################
la-linux-dtbs:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs -j$(CPU_NUM)
la-linux-dtbs_clean:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs_clean -j$(CPU_NUM)	
la-linux-dtbs_install:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs_install -j$(CPU_NUM)		
la-sd-install-linux-dtbs-0601:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs-sd-install-0601 
la-sd-install-linux-dtbs-0700:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs-sd-install-0700  -j$(CPU_NUM)
la-sd-install-linux-dtbs-0702:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs-sd-install-0702  -j$(CPU_NUM)
la-sd-install-linux-dtbs-0703:
	$(MAKE) -C $(PSDKLA_PATH) linux-dtbs-sd-install-0703  -j$(CPU_NUM)
##########################################
#                                        #
# uboot-r5                               #
#                                        #
##########################################
la-u-boot-r5:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-r5 -j$(CPU_NUM)
la-u-boot-r5_clean:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-r5_clean -j$(CPU_NUM)	
la-u-boot-r5_install:
	$(MAKE) -C $(PSDKLA_PATH) u-boot-r5_install -j$(CPU_NUM)	
##########################################
#                                        #
# jailhouse                              #
#                                        #
##########################################	
la-jailhouse:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse -j$(CPU_NUM)
la-jailhouse_clean:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse_clean -j$(CPU_NUM)	
la-jailhouse_config:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse_config -j$(CPU_NUM)	
la-jailhouse_install:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse_install -j$(CPU_NUM)	
la-jailhouse_install_sd:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse_install_sd -j$(CPU_NUM)	
la-jailhouse_distclean:
	$(MAKE) -C $(PSDKLA_PATH) jailhouse_distclean -j$(CPU_NUM)	
#==============================================================================
# install the staus. 
#==============================================================================	
la-install_yoctolayer:	
	cd $(PSDKLA_PATH)/yocto-build && ./oe-layertool-setup.sh -f $(PSDKLA_PATH)/yocto-build/configs/psdkla/la-06_00_01_00.txt

la-install_yocto_env:
	cd $(PSDKLA_PATH)/yocto-build/build && . conf/setenv
	@echo "please use below command to compile"
	@echo "TOOLCHAIN_BASE=/home/fredy/j7/psdk_rtos_auto_j7_06_00_00_00/ MACHINE=j7-evm bitbake -k tisdk-rootfs-image"
#==============================================================================
# A help message target.
#==============================================================================
la_help:
	@echo
	@echo "PSDKRA_PATH : $(PSDKRA_PATH)"
	@echo "PSDKLA_PATH : $(PSDKLA_PATH)"
	@echo "BOOT   : $(BOOT)"
	@echo "ROOTFS : $(ROOTFS)"
	@echo "Available build targets are  :"
	@echo            
	@echo "    sysfw-image                    : Build sysfw-image"
	@echo "    sysfw-image_clean              : clean sysfw-image"
	@echo "    sysfw-image_install            : sysfw-image_install"
	@echo 
	@echo "    u-boot-a53                     :  "
	@echo "    u-boot-a53_clean               :  "
	@echo "    u-boot-a53_install             :  "　
	@echo "    u-boot-a53_spl_sd              : instal tispl.bin to SD boot partition  "　
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
