#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

ubuntu-install-basic: 
	$(Q)$(ECHO) "install ubuntu basic"
	sudo apt install vim git repo wget curl gitk
	$(Q)$(ECHO) "ubuntu install done!"

# docker --------------start
ubuntu-docker-install:
	sudo apt update
	sudo apt install -y docker.io

ubuntu-docker-test:
	docker run hello-world

ubuntu-install-docker-yocto: 
	docker pull jwidic/ubuntu18.04yocto
# docker --------------done

ubuntu18-install-tftp: check_paths_fredy_scripts
	sudo apt-get install tftpd
	# install ubuntu18 the tftp
	cd $(SCRIPTS_PATH)/ubuntu && ./setup-tftp.sh
	# ubuntu18 install done!

ubuntu18-install-nfs: check_paths_fredy_scripts
	sudo apt install nfs-kernel-server
	# install ubuntu18 the tftp
	cd $(SCRIPTS_PATH)/ubuntu && ./setup-targetfs-nfs.sh
	# ubuntu18 install done!

ubuntu-install-usbrelay: 
	# install ubuntu18 usbrelay
	sudo apt install usbrelay
	# ubuntu18 install usbrepay done!

ubuntu18-install-chromium: 
	# install ubuntu18 
	sudo apt install chromium-browser
	# ubuntu18 install done!

ubuntu-install-geany: 
	# install ubuntu18
	sudo apt install geany
	# ubuntu18 install done!

ubuntu-docker-yocto-ubuntu18-j7: check_paths_PSDKLA
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123"
	docker run -t -i -v $(jacinto_PATH):$(jacinto_PATH) jwidic/ubuntu18.04yocto  /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"


ubuntu-install-help:
	$(Q)$(ECHO)
	$(Q)$(ECHO) "Available build targets are  :"
	$(Q)$(ECHO) "    ----------------Build --------------------------------------  "
	$(Q)$(ECHO) "    ubuntu-install-basic    "
	$(Q)$(ECHO) "    ubuntu-docker-install   "
	$(Q)$(ECHO) "    ubuntu-docker-test       "
	$(Q)$(ECHO) "    ubuntu-install-docker-yocto  "
	$(Q)$(ECHO) "    ubuntu18-install-tftp   : ubuntu18-install-tftp"
	$(Q)$(ECHO) "    ubuntu18-install-nfs    : ubuntu18-install-nfs"
	$(Q)$(ECHO) "    ubuntu-install-usbrelay      : ubuntu-install-usbrelay"
	$(Q)$(ECHO) "    ubuntu18-install-chromium      : ubuntu18-install-chromium"
	$(Q)$(ECHO) "    ubuntu-install-geany:     : ubuntu-install-geany"
	$(Q)$(ECHO) "    ubuntu-docker-yocto-ubuntu18-j7:     : ubuntu-docker-yocto-ubuntu18-j7"
	$(Q)$(ECHO) "    ---------------- ending  !!!--------------------------------------  "