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
	$(Q)$(ECHO) "#   PSDKRA_PATH : $(PSDKRA_PATH)"
	$(Q)$(ECHO) "#   PSDKLA_PATH : $(PSDKLA_PATH)"
	$(Q)$(ECHO) "#   BOOT        : $(BOOT)"
	$(Q)$(ECHO) "#   ROOTFS      : $(ROOTFS)"
	$(Q)$(ECHO) "#   WORK_PATH   : $(WORK_PATH)"
	$(Q)$(ECHO) "#   jacinto_PATH: $(jacinto_PATH)"
	$(Q)$(ECHO) "    ----------------important configure flags -------------------------------------  "
	$(Q)$(ECHO) "    print_config   : show the includ in this build"
	$(Q)$(ECHO) "    print_env      : print_evn setting"
	$(Q)$(ECHO) "    print_variable : print_evn setting"
	$(Q)$(ECHO) "     "
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "

umount: 
	$(Q)$(ECHO) "umount BOOT"
	$(Q)if [ -d $(BOOT) ]; then umount $(BOOT);  fi
	$(Q)$(ECHO) "umount boot"
	$(Q)if [ -d $(BOOT1) ]; then umount $(BOOT1);  fi
	$(Q)$(ECHO) "umount rootfs"
	$(Q)if [ -d $(ROOTFS) ]; then umount $(ROOTFS);  fi
	$(Q)$(ECHO) "umount done!!!"	
