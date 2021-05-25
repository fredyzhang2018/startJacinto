##########################################
#                                        #
# prepare sd:                            #
#                                        #
##########################################
sd_install_video: check_paths_sd_rootfs
	@echo "rootfs install video for video testing"
	@sudo cp -r -v $(resouce_PATH)/video/* $(ROOTFS)/home
	@echo "video install done!"


sd_mk_partition:
	@echo " >>>>> do SD mk partition as below:"
	@echo " >>>>> Use the command "df -h" to identify the device used by SD card"
	@echo " >>>>> option1: Unmount the SD card before running the script"
	@echo "                umount /dev/sdb1"
	@echo "                umount /dev/sdb1"
	@echo " >>>>>          sudo psdk_rtos_auto/scripts/mk-linux-card.sh /dev/sdb "
	@echo " >>>>>          end !!!  "
	@echo " >>>>> option2:  you can use "gparted" utility (sudo apt install gparted) to use a GUI based interface to create the partitions "
	@echo " >>>>>          Make sure you set the FAT32 partition flags as "boot", "lba" " 
	@echo " >>>>>          Name the FAT32 partition as "BOOT" and the ext4 partition as "rootfs" " 
	@echo " >>>>>          end !!!  "

sd_install_boot:
	@echo " >>>>> Copy boot loader files to sd boot partition"
	@echo " >>>>> will update later, not update now"

sd_install_rootfs:
	@echo "install the rootfs to SD card"
	cd ${PSDKRA_PATH} && psdk_rtos_auto/scripts/install_to_sd_card.sh
	sync
	@echo "install done!!!"
sd_install_auto_ti_data:
	@echo "Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/$USER/rootfs/"
	mkdir -p $(ROOTFS)/opt/vision_apps
	cd $(ROOTFS)/opt/vision_apps && tar --strip-components=1 -xf $(DOWNLOADS_PATH)/psdk_rtos_ti_data_set_ptk_07_01_00.tar.gz
	@echo "install done!!!"
sd_install_apps_binaries:
	@echo "Do below to copy vision apps binaries to SD card"
	mkdir -p $(ROOTFS)/opt/vision_apps
	cd ${PSDKRA_PATH}/vision_apps && make linux_fs_install_sd
	@echo "install done!!!"	
sd_linux_fs_install_sd:
	@echo "Do below to copy vision apps binaries to SD card"
	cd ${PSDKRA_PATH}/vision_apps && make linux_fs_install_sd
	@echo "install done!!!"	
	

