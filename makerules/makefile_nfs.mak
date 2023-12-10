##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################

# ## Can Profiling Application
nfs-setup-psdkla:
	$(Q)$(ECHO) "start to setup nfs psdkla";
	$(Q)$(ECHO) "# 1. Setup TFTP. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-tftp.sh -s $(SJ_PATH_PSDKLA) # ./setup-tftp.sh SDK Path. 
	$(Q)$(ECHO) "# 2. Setup NFS. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKLA)/targetNFS
	$(Q)$(ECHO) "# 3. uboot env setup. ";
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkla.sh $(SJ_PATH_PSDKLA)/targetNFS $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 3. setup minicom ";
	$(Q)echo "done !!!";	

nfs-setup-psdkra:
	$(Q)$(ECHO) "start to setup nfs psdkra";
	$(Q)$(ECHO) "# 1. Setup NFS Dictionary ";
	# cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKRA)/targetfs
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkra.sh $(SJ_PATH_PSDKRA)/targetfs $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 2. setup minicom ";
	$(Q)echo "done !!!";	

nfs-setup-psdkra-edgeai:
	$(Q)$(ECHO) "start to setup nfs psdkra";
	$(Q)$(ECHO) "# 1. Setup NFS Dictionary ";
	# cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKRA)/targetfs
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkra_edgeai.sh $(SJ_PATH_PSDKRA)/targetfs $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 2. setup minicom ";
	$(Q)echo "done !!!";	

nfs-setup-minicom:
	$(Q)$(ECHO) "start to setup minicom ";
	#read -p "[ `ls /dev/ttyUSB*` ] :" IP_ADDRESS ;\
	sudo minicom -w -S $(SJ_PATH_SCRIPTS)/j7/nfs/bin/setupBoard.minicom

nfs-setup-uboot-img-prebuild:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup nfs-setup-uboot-img-prebuild:... ");
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/sysfw.itb    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
endif
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3.bin   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tispl.bin    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup nfs-setup-uboot-img-prebuild:... done!!!");

nfs-setup-tftp-psdkla-default:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKLA... ");
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo         /tftpboot/
ifeq ($(SJ_SOC_TYPE),j721e)
ifeq ($(SJ_VER_SDK),09)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin               /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin               /tftpboot/ti/
else 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-j7-evm.bin                           /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-j7-evm.bin                           /tftpboot/ti/
endif
else 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin               /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/Image-$(SJ_SOC_TYPE)-evm.bin               /tftpboot/ti/
endif
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb    /tftpboot/ti/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo         /tftpboot/ti/
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKLA... done!!! ");


nfs-setup-uboot-img-tftp:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup nfs-setup-uboot-img-tftp ... ");
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/sysfw.itb    /tftpboot 
endif
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3.bin  /tftpboot 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tispl.bin    /tftpboot 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img   /tftpboot 
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup nfs-setup-uboot-img-tftp ... done!!!");

nfs-setup-psdkra-spl-default:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup boot image for PSDKLA... ");
	$(Q)mkdir -p /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/tiboot3.bin                                                       /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/tispl.bin                                                         /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/u-boot.img                                                        /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/uEnv.txt                                                          /tftpboot/spl_default
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup boot image for PSDKLA... done!!! ");


#  J721E : '2 lib/firmware/j7-main-r5f0_0-fw 3 lib/firmware/j7-main-r5f0_1-fw 6 lib/firmware/j7-c66_0-fw 7 lib/firmware/j7-c66_1-fw 8 lib/firmware/j7-c71_0-fw'
nfs-setup-tftp-psdkra:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... ");
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out       /tftpboot/j7-main-r5f0_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out       /tftpboot/j7-main-r5f0_1-fw 
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_1.out        /tftpboot/j7-c66_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_2.out        /tftpboot/j7-c66_1-fw
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out        /tftpboot/j7-c71_0-fw
else ifeq ($(SJ_SOC_TYPE),j721s2)
	# J721S2 : setenv rproc_fw_binaries '2 /lib/firmware/j721s2-main-r5f0_0-fw 3 /lib/firmware/j721s2-main-r5f0_1-fw 6 /lib/firmware/j721s2-c71_0-fw 7 /lib/firmware/j721s2-c71_1-fw'
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f0_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f0_1-fw 
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out       /tftpboot/$(SJ_SOC_TYPE)-c71_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/targetfs/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_2.out       /tftpboot/$(SJ_SOC_TYPE)-c71_1-fw
endif
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");

nfs-setup-tftp-psdkra-sbl:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tiboot3.bin              /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tifs.bin                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/app                      /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp1                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp2                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/atf_optee.appimage       /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tidtb_linux.appimage                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tikernelimage_linux.appimage         /tftpboot/
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");

nfs-setup-tftp-psdkra-sbl-ospi:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/sbl_cust_img_mcu1_0_release.tiimage       /tftpboot/tiboot3.bin
	# $(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/sbl_ospi_img_mcu1_0_release.tiimage     /tftpboot/tiboot3.bin
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tifs.bin                                  /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/app_ospi                 /tftpboot/app
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp1                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp2                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/atf_optee.appimage       /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tidtb_linux.appimage                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tikernelimage_linux.appimage         /tftpboot/
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");

nfs-setup-tftp-psdkra-sbl-combined-opt:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tiboot3.bin                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_opt.appimage       /tftpboot/app
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");

nfs-setup-tftp-psdkra-sbl-combined-dev:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tiboot3.bin                          /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_dev.appimage       /tftpboot/app
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img                           /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/uEnv.txt                             /tftpboot/
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");

nfs-setup-uboot-img:
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup uboot img ...  ");
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/r5/tiboot3.bin                        $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/a72/tispl.bin                         $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/a72//u-boot.img                       $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(call sj_echo_log, 0 , " --- 0. start to setup uboot img ...  done!!!");

## Print CCS path 
nfs-help:
	$(Q)$(ECHO) "nfs-setup-psdkla  : Install for psdkla"
	$(Q)$(ECHO) "nfs-setup-psdkra  : Install for psdkra"
	$(Q)$(ECHO) "nfs-setup-minicom : Checking minicom, before running this, you need to set the right uart first."
	$(Q)$(ECHO) "nfs-setup-uboot-img : copy the spl/uboot to the tools dictionary.  "

 