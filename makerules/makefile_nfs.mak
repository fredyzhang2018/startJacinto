##########################################
#                                        #
# MCUSS                                  #
#                                        #
##########################################

# ## Can Profiling Application
nfs-setup-la:
	$(Q)$(ECHO) "start to setup nfs ";
	$(Q)$(ECHO) "# 1. Setup TFTP. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-tftp.sh -s $(SJ_PATH_PSDKLA) # ./setup-tftp.sh SDK Path. 
	$(Q)$(ECHO) "# 2. Setup NFS. ";
	#cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKLA)/targetNFS
	$(Q)$(ECHO) "# 3. uboot env setup. ";
	cd $(SJ_PATH_SCRIPTS)/j7/nfs && ./setup.sh $(SJ_PATH_PSDKLA)/targetNFS $(SJ_PATH_SCRIPTS) # ./setup targetNFS  scripts path
	$(Q)$(ECHO) "# 3. setup minicom ";
	$(Q)echo "done !!!";	
nfs-setup-minicom:
	$(Q)$(ECHO) "start to setup minicom ";
	#read -p "[ `ls /dev/ttyUSB*` ] :" IP_ADDRESS ;\
	sudo minicom -w -S $(SJ_PATH_SCRIPTS)/j7/nfs/bin/setupBoard.minicom

nfs-setup-uboot-img:
	$(Q)$(ECHO) "start to setup uboot img ";
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/sysfw.itb    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/j721e-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tiboot3.bin   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/j721e-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/tispl.bin    $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/j721e-evm
	$(Q)$(CP) $(SJ_PATH_PSDKLA)/board-support/prebuilt-images/u-boot.img   $(SJ_PATH_JACINTO)/tools/host-tools/k3-bootswitch/bin/j721e-evm



## Print CCS path 
nfs-help:
	$(Q)$(ECHO) "nfs help"
	$(Q)$(ECHO) "nfs-setup-la "
 