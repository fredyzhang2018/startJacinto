##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################

# ## Can Profiling Application
nfs_setup_psdkla:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkla ... "); 
	$(Q)$(ECHO) "start to setup nfs psdkla";
	$(Q)$(ECHO) "# 1. Setup TFTP. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-tftp.sh -s $(SJ_PATH_PSDKLA) # ./setup-tftp.sh SDK Path. 
	$(Q)$(ECHO) "# 2. Setup NFS. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKLA)/targetNFS
	$(Q)$(ECHO) "# 3. uboot env setup. ";
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkla.sh $(SJ_PATH_PSDKLA)/targetNFS $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 3. setup minicom ";
	$(Q)echo "done !!!";	
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkla ... done!"); 

nfs_setup_psdkra:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra ... "); 
	$(Q)$(ECHO) "start to setup nfs psdkra";
	$(Q)$(ECHO) "# 1. Setup NFS Dictionary ";
	# cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKRA)/targetfs
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkra.sh $(SJ_PATH_PSDKRA)/targetfs $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 2. setup minicom ";
	$(Q)echo "done !!!";	
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra ... done!"); 

nfs_setup_psdkra_edgeai:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra_edgeai ... "); 
	$(Q)$(ECHO) "start to setup nfs psdkra";
	$(Q)$(ECHO) "# 1. Setup NFS Dictionary ";
	# cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKRA)/targetfs
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./nfs_setup_psdkra_edgeai.sh $(SJ_PATH_PSDKRA)/targetfs $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 2. setup minicom ";
	$(Q)echo "done !!!";	
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra_edgeai ...done! "); 

nfs_setup_minicom:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_minicom ... "); 
	$(Q)$(ECHO) "start to setup minicom ";
	#read -p "[ `ls /dev/ttyUSB*` ] :" IP_ADDRESS ;\
	sudo minicom -w -S $(SJ_PATH_SCRIPTS)/j7/nfs/bin/setupBoard.minicom
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_minicom ... done!"); 

nfs_setup_uboot_img_prebuild:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img_prebuild ... "); 
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/sysfw.itb    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
endif
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3.bin   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tispl.bin    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img_prebuild ... done! "); 

nfs_setup_tftp_psdkla_default:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkla_default ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKLA... ");
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-common-proc-board.dtb    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-vision-apps.dtbo         /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo         /tftpboot/
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
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/k3-$(SJ_SOC_TYPE)-edgeai-apps.dtbo         /tftpboot/ti/
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKLA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkla_default ... done! "); 

nfs_setup_uboot_img_tftp:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img_tftp ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup nfs_setup_uboot_img_tftp ... ");
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/sysfw.itb    /tftpboot 
endif
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3.bin  /tftpboot 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tispl.bin    /tftpboot 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img   /tftpboot 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup nfs_setup_uboot_img_tftp ... done!!!");
	$(Q)$(call sj_echo_log, info , "# mcusw_help ... done"); 
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img_tftp ... done! "); 

nfs_setup_psdkra_spl_default:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra_spl_default ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup boot image for PSDKLA... ");
	$(Q)mkdir -p /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/tiboot3.bin                                                       /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/tispl.bin                                                         /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/u-boot.img                                                        /tftpboot/spl_default
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/bootfs/uEnv.txt                                                          /tftpboot/spl_default
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup boot image for PSDKLA... done!!! ");
	$(Q)$(call sj_echo_log, info , "# mcusw_help ... done"); 
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_psdkra_spl_default ... done! "); 


#  J721E : '2 lib/firmware/j7-main-r5f0_0-fw 3 lib/firmware/j7-main-r5f0_1-fw 6 lib/firmware/j7-c66_0-fw 7 lib/firmware/j7-c66_1-fw 8 lib/firmware/j7-c71_0-fw'
nfs_setup_tftp_psdkra:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
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
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra ... done!"); 

#  J721E : '2 lib/firmware/j7-main-r5f0_0-fw 3 lib/firmware/j7-main-r5f0_1-fw 6 lib/firmware/j7-c66_0-fw 7 lib/firmware/j7-c66_1-fw 8 lib/firmware/j7-c71_0-fw'
nfs_setup_tftp_psdkla:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkla ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
ifeq ($(SJ_SOC_TYPE),j721e)
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out       /tftpboot/j7-main-r5f0_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out       /tftpboot/j7-main-r5f0_1-fw 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_1.out        /tftpboot/j7-c66_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_2.out        /tftpboot/j7-c66_1-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out        /tftpboot/j7-c71_0-fw
else ifeq ($(SJ_SOC_TYPE),j721s2)
	# J721S2 : setenv rproc_fw_binaries '2 /lib/firmware/j721s2-main-r5f0_0-fw 3 /lib/firmware/j721s2-main-r5f0_1-fw 	4 /lib/firmware/j721s2-main-r5f1_0-fw 5 /lib/firmware/j721s2-main-r5f1_1-fw 6 /lib/firmware/j721s2-c71_0-fw 7 /lib/firmware/j721s2-c71_1-fw'
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f0_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f0_1-fw 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu3_0.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f1_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu3_1.out       /tftpboot/$(SJ_SOC_TYPE)-main-r5f1_1-fw 
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out        /tftpboot/$(SJ_SOC_TYPE)-c71_0-fw
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/targetNFS/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_2.out        /tftpboot/$(SJ_SOC_TYPE)-c71_1-fw
endif
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkla ... done!"); 

nfs_setup_tftp_psdkra_sbl:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tiboot3.bin              /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tifs.bin                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/app                      /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp1                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/lateapp2                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/atf_optee.appimage       /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tidtb_linux.appimage                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tikernelimage_linux.appimage         /tftpboot/
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl ... done! "); 

nfs_setup_tftp_psdkra_sbl_ospi:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_ospi ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
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
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_ospi ... done!"); 

nfs_setup_tftp_psdkra_sbl_combined_opt:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_combined_opt ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tiboot3.bin                 /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_opt.appimage       /tftpboot/app
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_combined_opt ... done!"); 

nfs_setup_tftp_psdkra_sbl_combined_dev:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_combined_dev ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... ");
	rm -rf /tftpboot/*
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_bootfiles/tiboot3.bin                          /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/tifs.bin                    /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKRA)/vision_apps/out/sbl_combined_bootfiles/combined_dev.appimage       /tftpboot/app
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img                           /tftpboot/
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/uEnv.txt                             /tftpboot/
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup tftp boot image for PSDKRA... done!!! ");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_tftp_psdkra_sbl_combined_dev ... done!"); 

nfs_setup_uboot_img:
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img ... "); 
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup uboot img ...  ");
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/r5/tiboot3.bin                        $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/a72/tispl.bin                         $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(CP) $(SJ_PATH_UBOOT)/build/a72//u-boot.img                       $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/$(SJ_SOC_TYPE)-evm
	$(Q)$(call sj_echo_log, info , " --- 0. start to setup uboot img ...  done!!!");
	$(Q)$(call sj_echo_log, info , "1. nfs_setup_uboot_img ... done! "); 

## Print CCS path 
nfs_help:
	$(Q)$(call sj_echo_log, info , "# nfs_help ... "); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_psdkla", "Install for psdkla..."); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_psdkra", "Install for psdkra ..."); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_minicom", "Checking minicom: before running this. you need to set the right uart first. ..."); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_uboot_img", "copy the spl/uboot to the tools dictionary. ...");
	$(Q)$(call sj_echo_log, help , "nfs_setup_psdkra_edgeai","update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_psdkra_spl_default", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkla", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkla_default", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkra", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkra_sbl", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkra_sbl_combined_dev", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkra_sbl_combined_opt", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_tftp_psdkra_sbl_ospi", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_uboot_img_prebuild", "setup the prebuild image to host-tools "); 
	$(Q)$(call sj_echo_log, help , "nfs_setup_uboot_img_tftp", "update later ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "# nfs_help ... done!"); 