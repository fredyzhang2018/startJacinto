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
la_uboot:     
	$(Q)$(call sj_echo_log, info , "1. la_uboot ... "); 
	cd $(SJ_PATH_PSDKLA) && $(MAKE)  u-boot
	$(Q)$(call sj_echo_log, info , "1. la_uboot ... done!"); 

la_uboot_clean:
	$(Q)$(call sj_echo_log, info , "1. la_uboot_clean ... "); 
	cd $(SJ_PATH_PSDKLA) && $(MAKE)  u-boot_clean
	$(Q)$(call sj_echo_log, info , "1. la_uboot_clean ... done!"); 
la_sd_install_uboot:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot ... "); 
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
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot ... done!"); 
	
la_sd_install_uboot_a53:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_a53 ... "); 
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
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_a53 ... done!"); 
	
la_sd_install_uboot_tispl:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_tispl ... "); 
	@if [ ! $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin $(SJ_BOOT1); \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/tispl.bin $(SJ_BOOT); \
	fi
	sync
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_tispl ... done!"); 

la_sd_install_uboot_tiboot3:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_tiboot3 ... "); 
	@if [ -d $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT)	; \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/r5/tiboot3.bin $(SJ_BOOT1)	; \
	fi
	sync
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_tiboot3 ... done!"); 

la_sd_install_uboot_uboot_img:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_uboot_img ... "); 
	@if [ ! $(SJ_BOOT) ] ; then \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT1); \
	else \
		install $(SJ_PATH_PSDKLA)/board-support/u-boot_build/a72/u-boot.img $(SJ_BOOT); \
	fi
	sync
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_uboot_uboot_img ... done!"); 
	
##########################################
#                                        #
# sysfw-image                            #
#                                        #
##########################################
la_sysfw_image:
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image ... done!"); 
la_sysfw_image_clean:
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image_clean ... done!"); 
la_sysfw_image_install:
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image_install ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) sysfw-image_install -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_sysfw_image_install ... done!"); 

##########################################
#                                        #
# linux                                  #
#                                        #
##########################################
la_linux:
	$(Q)$(call sj_echo_log, info , "1. la_linux ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_linux ... done!"); 
la_linux_clean:
	$(Q)$(call sj_echo_log, info , "1. la_linux_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_linux_clean ... done!"); 

la_linux_install:
	$(Q)$(call sj_echo_log, info , "1. la_linux_install ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux_install -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_linux_install ... done!"); 
la_sd_linux_install:
	$(Q)$(call sj_echo_log, info , "1. la_sd_linux_install ... "); 
	sudo $(MAKE) -C $(SJ_PATH_PSDKLA) linux_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)
	sync
	$(Q)$(call sj_echo_log, info , "1. la_sd_linux_install ... done!"); 

la_nfs_linux_install_psdkra:
	$(Q)$(call sj_echo_log, info , "1. la_nfs_linux_install_psdkra ... "); 
	sudo $(MAKE) -C $(SJ_PATH_PSDKLA) linux_install ROOTFS_PART=$(SJ_PATH_PSDKRA)/targetfs -j$(CPU_NUM)
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/Image $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb  $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo
	sync
	$(Q)$(call sj_echo_log, info , "1. la_nfs_linux_install_psdkra ... done!"); 


la_nfs_linux_install_psdkla:
	$(Q)$(call sj_echo_log, info , "1. la_nfs_linux_install_psdkla ... "); 
	sudo $(MAKE) -C $(SJ_PATH_PSDKLA) linux_install ROOTFS_PART=$(SJ_PATH_PSDKLA)/targetNFS/ -j$(CPU_NUM)
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/Image $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb  $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo
	sync
	$(Q)$(call sj_echo_log, info , "1. la_nfs_linux_install_psdkla ... done!"); 

##########################################
#                                        #
# linux dtb                              #
#                                        #
##########################################
la_linux_dtbs:
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs ... done!"); 
la_linux_dtbs_clean:
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs_clean ... done!"); 
la_linux_dtbs_install:
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs_install ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_install -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_linux_dtbs_install ... done!"); 	
la_sd_install_linux_dtbs:
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_linux_dtbs ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_sd_install_linux_dtbs ... done!"); 
la_nfs_install_linux_dtbs:
	$(Q)$(call sj_echo_log, info , "1. la_nfs_install_linux_dtbs ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) linux-dtbs_install ROOTFS_PART=$(SJ_PATH_PSDKRA)/targetfs/ -j$(CPU_NUM)
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb  $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo
	@cp -v $(SJ_PATH_PSDKLA)/board-support/built-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo
	ls -l $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)*
	$(Q)$(call sj_echo_log, info , "1. la_nfs_install_linux_dtbs ... done!"); 
##########################################
#                                        #
# GPU build                              #
#                                        #
##########################################
la_gpu:
	$(Q)$(call sj_echo_log, info , "1. la_gpu ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_gpu ... done!"); 
la_gpu_clean:
	$(Q)$(call sj_echo_log, info , "1. la_gpu_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_gpu_clean ... done!"); 
la_gpu_install:
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install ..."); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install ... done!"); 	
la_gpu_install_sd:
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_sd ... "); 
	sudo chown -R `whoami` $(SJ_ROOTFS)/lib/modules/
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_ROOTFS) -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_sd ... done!"); 

la_gpu_install_nfs_psdkla:
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_nfs_psdkla ... "); 
	sudo chown -R `whoami` $(SJ_PATH_PSDKLA)/targetNFS/lib/modules/
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_PATH_PSDKLA)/targetNFS/ -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_nfs_psdkla ... done!"); 

la_gpu_install_nfs_psdkra:
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_nfs_psdkra ... "); 
	sudo chown -R `whoami` $(SJ_PATH_PSDKRA)/targetfs/lib/modules/
	$(MAKE) -C $(SJ_PATH_PSDKLA) ti-img-rogue-driver_install ROOTFS_PART=$(SJ_PATH_PSDKRA)/targetfs/ -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_gpu_install_nfs_psdkra ... done!"); 

##########################################
#                                        #
# uboot-r5                               #
#                                        #
##########################################
la_uboot_r5:
	$(Q)$(call sj_echo_log, info , "1. la_uboot_r5 ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-r5 -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_uboot_r5 ... done!"); 

la_uboot_r5_clean:
	$(Q)$(call sj_echo_log, info , "1. la_uboot_r5_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-r5_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_uboot_r5_clean ... done!"); 


##########################################
#                                        #
# uboot-a72                               #
#                                        #
##########################################
la_uboot_a72:
	$(Q)$(call sj_echo_log, info , "1. la_uboot_a72 ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-a72 -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_uboot_a72 ... done!"); 

la_uboot_a72_clean:
	$(Q)$(call sj_echo_log, info , "1. la_uboot_a72_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) u-boot-a72_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_uboot_a72_clean ... done!"); 

##########################################
#                                        #
# remote run                               #
#                                        #
##########################################
#la-remote-run-command: la-update-remote-image
la_remote_run_command:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command ... done!"); 

la_remote_run_command_status_csi:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_csi ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/csi_registers_$(SJ_SOC_TYPE).sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./csi_registers_$(SJ_SOC_TYPE).sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/csi_registers_$(SJ_SOC_TYPE).sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_csi ... done!"); 

la_remote_run_command_status_dss:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_dss ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/dss_regdumps_$(SJ_SOC_TYPE).sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./dss_regdumps_$(SJ_SOC_TYPE).sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/dss_regdumps_$(SJ_SOC_TYPE).sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_dss ... done!"); 

la_remote_run_command_status_thermal:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_thermal ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/thermal_registers_$(SJ_SOC_TYPE).sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./thermal_registers_$(SJ_SOC_TYPE).sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/thermal_registers_$(SJ_SOC_TYPE).sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_thermal ... done!"); 

la_remote_run_command_status_serdes:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_serdes ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/thermal_registers_$(SJ_SOC_TYPE).sh-------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./serdes_status_$(SJ_SOC_TYPE).sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) $(SJ_PATH_SCRIPTS)/j7/thermal_registers_$(SJ_SOC_TYPE).sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_command_status_serdes ... done!"); 

la_update_remote_image: 
	$(Q)$(call sj_echo_log, info , "1. la_update_remote_image ... "); 
	$(Q)$(call sj_echo_log, info , " 0. update the iamge:$(SJ_PATH_PSDKRA)/scripts/j7/csi_registers_j721s2.sh ---- start !!!");
	scp $(SJ_PATH_JACINTO)/scripts/j7/csi_registers_j7.sh  root@$(SJ_EVM_IP):/home/root
	$(Q)$(call sj_echo_log, info , " 0. update the iamge:$(SJ_PATH_PSDKRA)/scripts/j7/csi_registers_j721s2.sh ---- Done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_update_remote_image ... done!"); 

la_remote_run_ssh:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_ssh ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the remote ssh -------------------------------- start !!!");
	ssh  root@$(SJ_EVM_IP) 
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_ssh ... done!"); 
	
la_remote_run_helloworld:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_helloworld ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- start !!!");
	scp $(SJ_PATH_SDK)/app/helloworld/helloworld  root@$(SJ_EVM_IP):/home/root
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_helloworld ... done!"); 

la_remote_run_fbimagesave:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_fbimagesave ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- start !!!");
	scp $(SJ_PATH_SDK)/app/fb_image_save/fb_image_save  root@$(SJ_EVM_IP):/home/root
	scp  /home/fredy/startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/vision_apps/out/J721S2/A72/LINUX/release/vx_app_vfb_image_display.out root@$(SJ_EVM_IP):/opt/vision_apps/
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh
	scp root@$(SJ_EVM_IP):/home/root/fb0.bin   ./
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_fbimagesave ... done!"); 

la_remote_run_vfb_usecase:
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_vfb_usecase ... "); 
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- start !!!");
	scp  /home/fredy/startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/vision_apps/out/J721S2/A72/LINUX/release/vx_app_vfb_image_display.out root@$(SJ_EVM_IP):/opt/vision_apps/
	# cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh
	$(Q)$(call sj_echo_log, info , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) ./remote_run.sh-------------------------------- done !!!");
	$(Q)$(call sj_echo_log, info , "1. la_remote_run_vfb_usecase ... done!"); 


la_hs_uboot:
	$(Q)$(call sj_echo_log, info , "1. la_hs_uboot ... "); 
	cd $(SJ_PATH_JACINTO)/sdks && git clone git://git.ti.com/security-development-tools/core-secdev-k3.git
	export TI_SECURE_DEV_PKG=$(SJ_PATH_JACINTO)/sdks/core-secdev-k3
	$(Q)$(call sj_echo_log, info , "1. la_hs_uboot ... done!"); 
	
##########################################
#                                        #
# jailhouse                              #
#                                        #
##########################################	
la_jailhouse:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse ... done!"); 
la_jailhouse_clean:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_clean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_clean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_clean ... done!"); 
la_jailhouse_config:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_config ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_config -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_config ... done!"); 
la_jailhouse_install:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_install ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_install -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_install ... done!"); 
la_jailhouse_install_sd:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_install_sd ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_install_sd -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_install_sd ... done!"); 
la_jailhouse_distclean:
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_distclean ... "); 
	$(MAKE) -C $(SJ_PATH_PSDKLA) jailhouse_distclean -j$(CPU_NUM)	
	$(Q)$(call sj_echo_log, info , "1. la_jailhouse_distclean ... done!"); 
#==============================================================================
# install the staus. 
#==============================================================================	
la_yocto_install_layer:	
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install_layer ... "); 
	cd $(SJ_PATH_PSDKLA)/yocto-build && ./oe-layertool-setup.sh -f $(SJ_PATH_PSDKLA)/yocto-build/configs/psdkla/la-06_00_01_00.txt
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install_layer ... done!"); 

la_yocto_install__env:
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install__env ... "); 
	cd $(SJ_PATH_PSDKLA)/yocto-build/build && . conf/setenv
	@echo "please use below command to compile"
	@echo "TOOLCHAIN_BASE=/home/fredy/j7/psdk_rtos_auto_j7_06_00_00_00/ MACHINE=j7-evm bitbake -k tisdk-rootfs-image"
	$(Q)$(call sj_echo_log, info , "1. la_yocto_install__env ... done!"); 
	
#==============================================================================
# QT the staus. 
#==============================================================================	
la_app_qt_showimage_build:
	$(Q)$(call sj_echo_log, info , "1. la_app_qt_showimage_build ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. build the QT show image: $(SJ_PATH_SDK)/QT/showImage ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/QT/showImage && ./makeImgShow
	$(Q)$(call sj_echo_log, info , " --- 1. build the QT show image: $(SJ_PATH_SDK)/QT/showImage --done!!! ");	
	$(Q)$(call sj_echo_log, info , "1. la_app_qt_showimage_build ... done!"); 

la_app_helloworld_build:
	$(Q)$(call sj_echo_log, info , "1. la_app_helloworld_build ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. build the hello world:  $(SJ_PATH_SDK)/app/helloworld/ ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/app/helloworld/ && make
	$(Q)$(call sj_echo_log, info , " --- 1. build the hello world:  $(SJ_PATH_SDK)/app/helloworld/ --done!!! ");	
	$(Q)$(call sj_echo_log, info , "1. la_app_helloworld_build ... done!"); 

la_app_helloworld_clean:
	$(Q)$(call sj_echo_log, info , "1. la_app_helloworld_clean ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. build the hello world:  $(SJ_PATH_SDK)/app/helloworld/  ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/app/helloworld/ && make clean
	$(Q)$(call sj_echo_log, info , " --- 1. build the hello world:  $(SJ_PATH_SDK)/app/helloworld/ --done!!! ");	
	$(Q)$(call sj_echo_log, info , "1. la_app_helloworld_clean ... done!");  

la_app_fbimagesave_build:
	$(Q)$(call sj_echo_log, info , "1. la_app_fbimagesave_build ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. build the fb_image_save: $(SJ_PATH_SDK)/app/fb_image_save/   ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/app/fb_image_save/ && make
	$(Q)$(call sj_echo_log, info , " --- 1. build the fb_image_save: $(SJ_PATH_SDK)/app/fb_image_save/ --done!!! ");	
	$(Q)$(call sj_echo_log, info , "1. la_app_fbimagesave_build ... done!"); 

la_app_fbimagesave_clean:
	$(Q)$(call sj_echo_log, info , "1. la_app_fbimagesave_clean ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. build the fb_image_save: $(SJ_PATH_SDK)/app/fb_image_save/ ");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_SDK)/app/fb_image_save/ && make clean
	$(Q)$(call sj_echo_log, info , " --- 1. build the fb_image_save: $(SJ_PATH_SDK)/app/fb_image_save/ --done!!! ");	
	$(Q)$(call sj_echo_log, info , "1. la_app_fbimagesave_clean ... done!"); 

#==============================================================================
# evm case running. 
#==============================================================================	
la_evm_app_testing_eth:
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_eth ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. testing application on evm ...  ");
	$(Q)$(call sj_echo_log, debug , " --- 1. input the times that you want to running ...  ");
	cd $(SJ_PATH_SCRIPTS) && ./j7/run_evm_test.sh  -r yes -m eth
	$(Q)$(call sj_echo_log, debug , " --- 1. will run  $(num) times. done! ");
	$(Q)$(call sj_echo_log, info , " --- 1. testing application on evm ...  ");
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_eth ... done!"); 

la_evm_app_testing_minicom:
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_minicom ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. testing application on evm ...  ");
	$(Q)$(call sj_echo_log, debug , " --- 1. input the times that you want to running ...  ");
	cd $(SJ_PATH_SCRIPTS) && ./j7/run_evm_test.sh  -r yes -m minicom
	$(Q)$(call sj_echo_log, debug , " --- 1. will run  $(num) times. done! ");
	$(Q)$(call sj_echo_log, info , " --- 1. testing application on evm ...  ");
	$(Q)$(call sj_echo_log, info , "1. la_evm_app_testing_minicom ... done!"); 

######################## evm Testing -----------------------------


#==============================================================================
# A help message target.
#==============================================================================
la_help:
	$(Q)$(call sj_echo_log, info , "1. pdk_build_configure ... "); 
	$(Q)$(call sj_echo_log, help ,"Variable Setting -------------------------------------------");
	$(Q)$(call sj_echo_log, file ,"SJ_PATH_PSDKRA ", "$(SJ_PATH_PSDKRA)");
	$(Q)$(call sj_echo_log, file ,"SJ_PATH_PSDKLA  ", "$(SJ_PATH_PSDKLA)");
	$(Q)$(call sj_echo_log, file ,"SJ_BOOT ", " $(SJ_BOOT)");
	$(Q)$(call sj_echo_log, file ,"SJ_ROOTFS", "$(SJ_ROOTFS)");
	$(Q)$(call sj_echo_log, info ,"# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "la_uboot","build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_uboot_a72", "build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_uboot_a72_clean", "build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_uboot_clean", "build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_uboot_r5", "build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_uboot_r5_clean", "build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux","build uboot ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux_clean", "build linux kernel ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux_dtbs", "build linux kernel ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux_dtbs_clean", "build linux kernel ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux_dtbs_install", "build linux kernel ... "); 
	$(Q)$(call sj_echo_log, help , "la_linux_install", "build linux kernel ... "); 
	$(Q)$(call sj_echo_log, help , "la_gpu","gpu building ... "); 
	$(Q)$(call sj_echo_log, help , "la_gpu_clean", "gpu build clean ... "); 
	$(Q)$(call sj_echo_log, help , "la_gpu_install", "gpu build install ... "); 
	$(Q)$(call sj_echo_log, help , "la_gpu_install_nfs_psdkla", "gpu build install for psdkla ... "); 
	$(Q)$(call sj_echo_log, help , "la_gpu_install_nfs_psdkra", "gpu build install for psdkra ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_command","remote run command ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_command_status_csi", "remote run command - check CSI status ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_command_status_dss", "remote run command - check DSS status ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_command_status_serdes", "remote run command - check SERDES status ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_command_status_thermal", "remote run command - check THERMAL status ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_fbimagesave", "remote run command -  fbimagesave ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_helloworld", "remote run command -  helloworld ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_ssh", "remote run command -  ssh ... "); 
	$(Q)$(call sj_echo_log, help , "la_remote_run_vfb_usecase",  "remote run command -  vfb usecase ... "); 
	$(Q)$(call sj_echo_log, help , "la_app_fbimagesave_build","app building ... "); 
	$(Q)$(call sj_echo_log, help , "la_app_fbimagesave_clean", "app cleanning ... "); 
	$(Q)$(call sj_echo_log, help , "la_app_helloworld_build", "app building ... "); 
	$(Q)$(call sj_echo_log, help , "la_app_helloworld_clean", "app cleanning ... "); 
	$(Q)$(call sj_echo_log, help , "la_app_qt_showimage_build", "app qt image building ... "); 
	$(Q)$(call sj_echo_log, help , "la_evm_app_testing_eth", "OpenVx usecase runnning - ethernet ... "); 
	$(Q)$(call sj_echo_log, help , "la_evm_app_testing_minicom", "OpenVx usecase runnning - minicom ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. sbl_help ... done!"); 


.PHONY: 
