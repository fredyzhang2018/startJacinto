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
print: print_config print_variable print_env 
print_all: print

# ANSI color codes
GRE=\033[0;32m
YEL=\033[0;33m
RED=\033[0;31m
BLU=\033[0;34m
PUR=\033[0;35m
CYA=\033[0;36m
WHI=\033[0;37m
RES=\033[0m
BOLD=\033[1m
ITAL=\033[3m
UNDE=\033[4m

help:
	$(Q)$(ECHO) "$(GRE)#   SJ_PATH_PSDKRA : $(SJ_PATH_PSDKRA)    $(RES)"
	$(Q)$(ECHO) "$(YEL)#   SJ_PATH_PSDKLA : $(SJ_PATH_PSDKLA) $(RES)"
	$(Q)$(ECHO) "$(RED)#   SJ_BOOT        : $(SJ_BOOT)"
	$(Q)$(ECHO) "$(BLU)#   SJ_ROOTFS      : $(SJ_ROOTFS)"
	$(Q)$(ECHO) "$(RES)#   SJ_WORK_PATH   : $(SJ_WORK_PATH)"
	$(Q)$(ECHO) "# $(RED)$(BOLD)  SJ_PATH_JACINTO: $(SJ_PATH_JACINTO) $(RES) "
	$(Q)$(ECHO) "    $(ITAL)----------------important configure flags ------------------------------------- $(RES) "
	$(Q)$(ECHO) "    $(PUR)$(ITAL)print_config   : show the includ in this build $(RES)"
	$(Q)$(ECHO) "    $(CYA)$(UNDE)print_env      : print_evn setting $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)print_variable : print_evn setting $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)help_all       : print all command for help info $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)log_help       : log command help $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)check_cmd               : seach CMD in makefile $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)check_cmd_content       : seach CMD and relative content in makefile $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)check_doc_jacinto7      : search notes on doc $(RES)"
	$(Q)$(ECHO) "    $(PUR)$(UNDE)check_scipts            : seach CMD in scripts directory $(RES)"
	$(Q)$(ECHO) "     "
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "


help_all: print_all help adb_help apps_help k3_bootswitch_help  mcusw_help check_paths_help ra_help_install sdk_git_help \
la_help_install nfs_help gateway_help sbl_help  pdk_help la_help ra_help tidl_help ubuntu_help


umount: 
	$(Q)$(call sj_echo_log, info , "1. umount $(SJ_BOOT) ... "); 
	$(Q)if [ -d $(SJ_BOOT) ]; then umount $(SJ_BOOT);  fi
	$(Q)$(call sj_echo_log, info , "2. umount $(SJ_BOOT1) ... "); 
	$(Q)if [ -d $(SJ_BOOT1) ]; then umount $(SJ_BOOT1);  fi
	$(Q)$(call sj_echo_log, info , "3. umount $(SJ_ROOTFS) ... "); 
	$(Q)if [ -d $(SJ_ROOTFS) ]; then umount $(SJ_ROOTFS);  fi
	$(Q)$(call sj_echo_log, info , "3. umount done! "); 

#sj_echo_log
# $0 : 0 print 1: log file 2: both 
# $1 : message
# file :  name - links. 
# help :  cmd  - comments. 
define sj_echo_log
	case $(1) in \
		info) \
			echo -e "${GRE}[ `date` ] ${GRE}$(BOLD)[--INFO--]$(RES) ==> ${GRE}$(2) ${RES}"; \
			echo -e "[ `date` ] INFO  ==> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		debug) \
			echo -e "${GRE}[ `date` ] ${PUR}$(BOLD)[--DEBUG-]$(RES) ==> ${PUR}$(2) ${RES}"; \
			echo -e "[ `date` ] DEBUG ==> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		error) \
			echo -e "${GRE}[ `date` ] ${RED}$(BOLD)[--ERROR-]$(RES) ==> ${RED}$(2) ${RES}"; \
			echo -e "[ `date` ] ERROR ==> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		warning) \
			echo -e "${GRE}[ `date` ] ${YEL}$(BOLD)[WARNING-]$(RES) ==> ${YEL}$(2) ${RES}"; \
			echo -e "[ `date` ] WARNING ==> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		critical) \
			echo -e "${GRE}[ `date` ] ${RED}$(BOLD)[CRITICAL]$(RES) ==> ${RED}$(2) ${RES}"; \
			echo -e "[ `date` ] CRITICAL ==> $(2)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		help) \
			echo -e "${GRE}# ${YEL}$(BOLD)$(2)$(RES): ${PUR}$(ITAL)$(3)${RES}"; \
			echo -e "[ `date` ] help ==> $(2) $(3)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		file) \
			echo -e "${GRE}# ${GRE}$(BOLD)$(2)$(RES): ${PUR}$(ITAL)$(3)$(RES)"; \
			echo -e "[ `date` ] help ==> $(2) $(3)"  >> $(SJ_PATH_JACINTO)/.sj_log; \
		;;   \
		*)   \
			echo -e "[ `date` $(3) ] >>> 0 INFO 1: DEBUG 2: ERROR 3: "; \
		;;   \
	esac
endef

log_help:
	$(Q)$(call sj_echo_log, info , "info example"); 
	$(Q)$(call sj_echo_log, warning , "debug example"); 
	$(Q)$(call sj_echo_log, debug , "debug example"); 
	$(Q)$(call sj_echo_log, error , "error example"); 
	$(Q)$(call sj_echo_log, critical , "critical example"); 
	$(Q)$(call sj_echo_log, help , "1. help","2. comments"); 
	$(Q)$(call sj_echo_log, file , "1. file" ,"2. file or link"); 

CMD ?= ubuntu
check_cmd:
	$(Q)$(call sj_echo_log, info , "check the cmd location: $(CMD)");
	$(Q)$(call sj_echo_log, warning , "Set CMD=\"\" check the commond...... ");
	$(Q)-grep -rni $(CMD) $(SJ_PATH_JACINTO)/makerules
	$(Q)-grep -rni $(CMD) $(SJ_PATH_JACINTO)/build_flags.mak
	$(Q)-grep -rni $(CMD) $(SJ_PATH_JACINTO)/tools_path.mak
	$(Q)-grep -rni $(CMD) $(SJ_PATH_JACINTO)/Makefile
	$(Q)$(call sj_echo_log, info , "check the cmd : $(CMD) location");

check_cmd_content:
	$(Q)$(call sj_echo_log, info , "check the cmd location: $(CMD)");
	$(Q)$(call sj_echo_log, warning , "Set CMD=\"\" check the commond...... ");
	$(Q)make help_all | grep $(CMD)
	$(Q)$(call sj_echo_log, info , "check the cmd : $(CMD) location");

check_scipts:
	$(Q)$(call sj_echo_log, info , "check the cmd location: $(CMD)");
	$(Q)$(call sj_echo_log, warning , "Set CMD=\"\" check the commond...... ");
	$(Q)-grep -rni $(CMD) $(SJ_PATH_JACINTO)/scripts
	$(Q)$(call sj_echo_log, info , "check the cmd : $(CMD) location");


check_doc_jacinto7:
	$(Q)$(call sj_echo_log, info , "check the content doc: $(CMD)");
	$(Q)$(call sj_echo_log, warning , "Set CMD=\"\" check the commond...... ");
	$(Q)grep -rni $(CMD) $(SJ_PATH_JACINTO)/docs/jacinto7
	$(Q)$(call sj_echo_log, info , "check the content doc: $(CMD)");


git_init:
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git init ... "); 
	$(Q)git submodule status|grep '^-' && git submodule init && \
		git submodule update || $(call sj_echo_log, info , "Git submodules: nothing to update"); 
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git init ... done!"); 
git_sync:
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git sync ... "); 
	$(Q)git submodule init && git submodule sync && \
		git submodule update --remote && \
		$(call sj_echo_log, info , "Git submodules: nothing to sync");
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git sync ... done!"); 


git_clean:
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git clean ... "); 
	$(Q)$(call sj_echo_log, warning , "WARNING WARNING WARNING ..."); 
	$(Q)$(call sj_echo_log, warning , "git clean -fdx git reset hard everything - including all submodules!"); 
	$(Q)$(call sj_echo_log, warning , "LL LOCAL CHANGES. uncommited changes. untracked files ARE NUKED WIPED OUT!!!!!!!!"); 
	$(Q)read -p 'Enter "y" to continue - any other character to abort: ' confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	$(call sj_echo_log, info , "Cleaning!"); 
	$(Q)$(shell git submodule foreach git clean -fdx >/dev/null)
	$(Q)$(shell git submodule foreach git reset --hard >/dev/null)
#	# $(Q)git clean -fdx
#	# $(Q)git reset --hard
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git clean ... done!"); 

git_deinit:
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git deinit ... "); 
	$(Q)$(call sj_echo_log, warning , "WARNING WARNING WARNING ..."); 
	$(Q)$(call sj_echo_log, warning , "git submodule deinit --all -f : This will WIPE OUT every git submodule details!!!"); 
	$(Q)$(call sj_echo_log, warning , "git clean -fdx git reset --hard everything -including all submodules!"); 
	$(Q)$(call sj_echo_log, warning , "ALL LOCAL CHANGES. uncommited changes. untracked files ARE NUKED/WIPED OUT!!!!!!!!"); 
	$(Q)read -p 'Enter "y" to continue - any other character to abort: ' confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	$(call sj_echo_log, info , "Cleaning!"); 
	$(Q)$(shell git submodule foreach git clean -fdx >/dev/null)
	$(Q)$(shell git submodule foreach git reset --hard >/dev/null)
#	# $(Q)git clean -fdx
#	# $(Q)git reset --hard
	$(Q)git submodule deinit --all -f
	$(Q)$(call sj_echo_log, info , "1. Git submodules: git deinit ... done!");

git_desc: git_init
	$(Q)$(shell git submodule foreach \
		'echo "    "`git rev-parse --abbrev-ref HEAD`" @"\
			`git describe --always --dirty` ":"\
			`git ls-remote --get-url`'\
		1>&2)
	$(Q)$(shell echo "I am at: "`git rev-parse --abbrev-ref HEAD` \
			"@" `git describe --always --dirty` ":"\
			`git ls-remote --get-url` 1>&2)

git_sync_remote_tag:
	$(Q)$(call sj_echo_log, info , "1. gitsync_remote ... "); 
	$(Q)git tag
	$(Q)$(call sj_echo_log, warning , "input tag for startjacinto and submoudle... "); 
	$(Q)read -p 'Enter "xx_xx_xx" tag : ' tag;\
	    read -p 'Enter "comments" comments : ' comments;\
	    read -p "Enter "y" to config (tag - $$tag : comments -$$comments ) - any other character to abort: " confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	git tag -a $$tag -m $$comments;\
	git submodule foreach git tag -a $$tag -m $$comments
	$(Q)$(call sj_echo_log, warning , "push tag to remote startjacinto and submoudle... "); 
	$(Q)read -p "Enter "y" to push content/tags to remote - any other character to abort: " confirm;\
	if [ "$$confirm" != y ]; then echo "Aborting"; exit 1; fi;\
	git push --tags;\
	git submodule foreach git push --tags;
	$(Q)$(call sj_echo_log, info , "1. gitsync_remote ... done!"); 

git_help:
	$(Q)$(call sj_echo_log, info , "#Makefile Help..... FOR Git Help"); 
	$(Q)$(call sj_echo_log, info , "#Use with care: "); 
	$(Q)$(call sj_echo_log, help , "git_init   ", "do a update of all git submodules"); 
	$(Q)$(call sj_echo_log, help , "git_sync   ", "sync all the git submodules"); 
	$(Q)$(call sj_echo_log, help , "git_clean", "thorough scrub of the projects - lose all changes. untracked files. etc"); 
	$(Q)$(call sj_echo_log, help , "git_deinit", "Delete the submodules and do a clean reset - thorough scrub of the projects - lose all changes. untracked files.etc. do a make gitsync after this to get back to normal"); 
	$(Q)$(call sj_echo_log, help , "git_desc   ", "describe where each git submodule commit and branch is"); 
	$(Q)$(call sj_echo_log, help , "git_sync_remote_tag   ", "sync local tag to remote..."); 
	$(Q)$(call sj_echo_log, info , "#Makefile Help..... FOR Git Help Done!"); 