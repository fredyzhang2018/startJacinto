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
	./ui_env_setup_jaicinto.sh -g 

umount: 
	$(Q)$(ECHO) "umount SJ_BOOT"
	$(Q)if [ -d $(SJ_BOOT) ]; then umount $(SJ_BOOT);  fi
	$(Q)$(ECHO) "umount SJ_BOOT"
	$(Q)if [ -d $(SJ_BOOT1) ]; then umount $(SJ_BOOT1);  fi
	$(Q)$(ECHO) "umount rootfs"
	$(Q)if [ -d $(SJ_ROOTFS) ]; then umount $(SJ_ROOTFS);  fi
	$(Q)$(ECHO) "umount done!!!"	

#sj_echo_log
# $0 : 0 print 1: log file 2: both 
# $1 : message
define sj_echo_log
	case $(1) in \
		0) \
			echo "[ `date` ] INFO  >>> $(2) "; \
			echo "[ `date` ] INFO >>> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		1) \
			if [ $(SJ_LOG_LEVEL) = 1 ]; then \
				echo "[ `date` ] DEBUG >>> $(2) "; \
				echo "[ `date` ] DEBUG >>> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
			fi; \
		;;   \
		2) \
			echo "[ `date` ] ERROR >>> $(2) "; \
			echo "[ `date` ] ERROR >>> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		*)   \
			echo "[ `date` $(3) ] >>> 0 INFO 1: DEBUG 2: ERROR 3:  "; \
		;;   \
	esac
endef


git:
	$(Q)git submodule status|grep '^-' && git submodule init && \
		git submodule update || echo 'Git submodules: nothing to update'

gitsync:
	$(Q)git submodule init && git submodule sync && \
		git submodule update --remote && \
		echo 'Git submodules: nothing to sync'

gitclean:
	$(Q)echo 'WARNING WARNING WARNING'
	$(Q)echo 'git clean -fdx;git reset --hard everything (including all submodules)!'
	$(Q)echo 'ALL LOCAL CHANGES, uncommited changes, untracked files ARE NUKED/WIPED OUT!!!!!!!!'
	$(Q)read -p 'Enter "y" to continue - any other character to abort: ' confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	echo "Cleaning!"
	$(Q)$(shell git submodule foreach git clean -fdx >/dev/null)
	$(Q)$(shell git submodule foreach git reset --hard >/dev/null)
	$(Q)git clean -fdx
	$(Q)git reset --hard

gitdeinit:
	$(Q)echo 'WARNING WARNING WARNING'
	$(Q)echo 'git submodule deinit --all -f  -> This will WIPE OUT every git submodule details!!!'
	$(Q)echo 'git clean -fdx;git reset --hard everything (including all submodules)!'
	$(Q)echo 'ALL LOCAL CHANGES, uncommited changes, untracked files ARE NUKED/WIPED OUT!!!!!!!!'
	$(Q)read -p 'Enter "y" to continue - any other character to abort: ' confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	echo "Cleaning!"
	$(Q)$(shell git submodule foreach git clean -fdx >/dev/null)
	$(Q)$(shell git submodule foreach git reset --hard >/dev/null)
	$(Q)git clean -fdx
	$(Q)git reset --hard
	$(Q)git submodule deinit --all -f

gitdesc: git
	$(Q)$(shell git submodule foreach \
		'echo "    "`git rev-parse --abbrev-ref HEAD`" @"\
			`git describe --always --dirty` ":"\
			`git ls-remote --get-url`'\
		1>&2)
	$(Q)$(shell echo "I am at: "`git rev-parse --abbrev-ref HEAD` \
			"@" `git describe --always --dirty` ":"\
			`git ls-remote --get-url` 1>&2)

githelp:
	$(Q)echo "Makefile Help..... **** FOR Git Help ****"
	$(Q)echo "This is a wrapper build script that tries to build everything we need"
	$(Q)echo
	$(Q)echo
	$(Q)echo "Use with care:"
	$(Q)echo "- git - do a update of all git submodules"
	$(Q)echo "- gitsync - sync all the git submodules"
	$(Q)echo "- gitclean - thorough scrub of the projects - lose all changes, untracked files, etc"
	$(Q)echo "- gitdeinit - Delete the submodules and do a clean reset - thorough scrub of the projects - lose all changes, untracked files, etc. do a make gitsync after this to get back to normal"
	$(Q)echo "- gitdesc - describe where each git submodule commit and branch is"