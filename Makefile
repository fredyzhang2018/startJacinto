#==============================================================================
# Makefile 
# Modified for projects Jacinto7 project
# By Fredy
# 2020-11-13
#==============================================================================
include tools_path.mak
include build_flags.mak
#==============================================================================
# A help message target.
#==============================================================================
print_all: print_config print_env print_variable


help:
	$(Q)$(ECHO) "#   SJ_PATH_PSDKRA : $(SJ_PATH_PSDKRA)"
	$(Q)$(ECHO) "#   SJ_PATH_PSDKLA : $(SJ_PATH_PSDKLA)"
	$(Q)$(ECHO) "#   SJ_BOOT        : $(SJ_BOOT)"
	$(Q)$(ECHO) "#   SJ_ROOTFS      : $(SJ_ROOTFS)"
	$(Q)$(ECHO) "#   SJ_WORK_PATH   : $(SJ_WORK_PATH)"
	$(Q)$(ECHO) "#   SJ_PATH_JACINTO: $(SJ_PATH_JACINTO)"
	$(Q)$(ECHO) "    ----------------important configure flags -------------------------------------  "
	$(Q)$(ECHO) "    print_config   : show the includ in this build"
	$(Q)$(ECHO) "    print_env      : print_evn setting"
	$(Q)$(ECHO) "    print_variable : print_evn setting"
	$(Q)$(ECHO) "     "
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "

umount: 
	$(Q)$(ECHO) "umount SJ_BOOT"
	$(Q)if [ -d $(SJ_BOOT) ]; then umount $(SJ_BOOT);  fi
	$(Q)$(ECHO) "umount SJ_BOOT"
	$(Q)if [ -d $(SJ_BOOT1) ]; then umount $(SJ_BOOT1);  fi
	$(Q)$(ECHO) "umount rootfs"
	$(Q)if [ -d $(SJ_ROOTFS) ]; then umount $(SJ_ROOTFS);  fi
	$(Q)$(ECHO) "umount done!!!"	
