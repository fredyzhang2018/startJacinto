#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

ubuntu-install-basic: 
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/install_sw.sh  !!!");
	cd $(SJ_PATH_SCRIPTS)/ubuntu/ && ./install_sw.sh -i install_ubuntu_basic
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/install_sw.sh --done !!!");

# docker --------------start
ubuntu-docker-install:
	sudo apt update
	sudo apt install -y docker.io

ubuntu-docker-test:
	docker run hello-world

ubuntu-install-docker-yocto: 
	docker pull jwidic/ubuntu18.04yocto
# docker --------------done

ubuntu-install-tftp: 
	sudo apt-get install tftpd tftp
	# install ubuntu18 the tftp
	cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-tftp.sh -s $(SJ_PATH_PSDKLA) # ./setup-tftp.sh SDK Path. 
	# ubuntu18 install done!

ubuntu-install-nfs: 
	sudo apt install nfs-kernel-server nfs-common
	# install ubuntu18 the tftp
	cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKLA)/targetNFS
	# ubuntu18 install done!

ubuntu-usbrelay-install: 
	# install ubuntu18 usbrelay
	sudo apt install usbrelay
	# ubuntu18 install usbrepay done!

ubuntu-usbrelay-start: 
	# install ubuntu18 usbrelay
	usbrelay HURTM_1=1 HURTM_2=1
	# ubuntu18 install usbrepay done!

ubuntu-usbrelay-close: 
	# install ubuntu18 usbrelay
	usbrelay HURTM_1=0 HURTM_2=0
	# ubuntu18 install usbrepay done!

ubuntu-install-chromium: 
	# install ubuntu18 
	sudo apt install chromium-browser
	# ubuntu18 install done!

ubuntu-install-geany: 
	# install ubuntu18
	sudo apt install geany
	# ubuntu18 install done!

ubuntu-launch-conky:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: launch the conky monitor!!!");
	$(Q)if [ -d /sys/bus/platform/devices/coretemp.0/hwmon/hwmon4 ]; then sed -i '/PacTemp/c \$$\{offset 15\}\$$\{font\}\$$\{color FFFDE2\}PacTemp: \$$\{platform coretemp.0/hwmon/hwmon4 temp 1\}°C CPUTemp: \$$\{platform coretemp.0/hwmon/hwmon4 temp 2\}°C HW' $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc; fi
	$(Q)if [ -d /sys/bus/platform/devices/coretemp.0/hwmon/hwmon3 ]; then sed -i '/PacTemp/c \$$\{offset 15\}\$$\{font\}\$$\{color FFFDE2\}PacTemp: \$$\{platform coretemp.0/hwmon/hwmon3 temp 1\}°C CPUTemp: \$$\{platform coretemp.0/hwmon/hwmon3 temp 2\}°C HW' $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc; fi
	conky -c $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc &
	$(Q)$(call sj_echo_log, 0 , "ubuntu: launch the conky monitor --done!!!");


ubuntu-launch-proxy:
	@echo "export http_proxy='http://127.0.0.1:8118'"
	@echo "export https_proxy=$http_proxy"


ubuntu-jupyter-start: 
	# install ubuntu18
	nohup jupyter notebook >/dev/null 2>&1 &
	# ubuntu18 install done!

ubuntu-unixbench-test:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/unixbench.sh !!!");
	cd $(SJ_PATH_SCRIPTS)/ubuntu/ && ./unixbench.sh -i yes -r yes
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/unixbench.sh --done !!!");

ubuntu-cpu-performance:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: CPU mode performace !!!");
	sudo cpufreq-set -r -g performance
	cpufreq-info | grep "current CPU frequency"
	$(Q)$(call sj_echo_log, 0 , "ubuntu: CPU mode performace --done!!!");

ubuntu-cpu-powersave:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: CPU mode performace !!!");
	sudo cpufreq-set -r -g powersave
	cpufreq-info | grep "current CPU frequency"
	$(Q)$(call sj_echo_log, 0 , "ubuntu: CPU mode performace --done!!!");


ubuntu-install-krusader:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the krusader !!!");
	sudo apt-get install krusader
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the krusader done !!!");


ubuntu-install-grabserial:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the grabserial !!!");
	sudo apt-get install grabserial
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the grabserial done !!!");

ubuntu-launch-grabserial:
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the grabserial !!!");
	sudo grabserial -v -S -d /dev/ttyUSB0 -t -m "Starting kernel"
	$(Q)$(call sj_echo_log, 0 , "ubuntu: install the grabserial done !!!");


ubuntu-jupyter-setup: 
	# install ubuntu18
	pip3 install jupyter  -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install pillow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install pycocotools -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install colorama -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install tqdm -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install pyyaml -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install pytest -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install notebook -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install ipywidgets -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install papermill --ignore-installed -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install munkres -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install json_tricks -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install --extra-index-url https://testpypi.python.org/pypi prototxt-parser -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	# ubuntu18 install done!

ubuntu-install-sublime:
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text

ubuntu-docker-ubuntu14: check_paths_PSDKLA
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123 or xxx"
	docker run -t -i -v $(SJ_PATH_JACINTO):$(SJ_PATH_JACINTO) jwidic/ubuntu:14.04yocto /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"

ubuntu-docker-ubuntu18: check_paths_PSDKLA
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123"
	docker run -t -i -v $(SJ_PATH_JACINTO):$(SJ_PATH_JACINTO) jwidic/ubuntu18.04yocto  /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"

ubuntu-install-pcan-tools:
	cd $(SJ_PATH_JACINTO)/tools/ && git clone ssh://git@10.85.130.233:7999/psdkra/peak-linux-driver-8.9.3.git
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3 && make all && sudo make install && sudo modprobe pcan

ubuntu-install-jacinto7-host-tools:
	cd $(SJ_PATH_JACINTO)/tools/ && git clone ssh://git@10.85.130.233:7999/psdkla/host-tools.git

# install opecv: two pamerater needed
SJ_OPENCV_PATH= $(SJ_PATH_JACINTO)/sdks
SJ_OPENCV_VERSION = 4.1.0
ubuntu-install-opencv:
	# install opecv: two pamerater needed 
	#     SJ_OPENCV_PATH    = $(SJ_OPENCV_PATH)
	#     SJ_OPENCV_VERSION = $(SJ_OPENCV_VERSION)
	$(SJ_PATH_SCRIPTS)/ubuntu/setup-opencv.sh $(SJ_OPENCV_PATH) $(SJ_OPENCV_VERSION)
	# setup done!


ubuntu-ssh-agent:
	echo "ssh-agent -s && ssh-agent bash && ssh-add ~/.ssh/id_rsa"

ubuntu-confluence-install:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-confluence.sh -i yes

ubuntu-confluence-launch:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-confluence.sh -l

ubuntu-postgresql-install:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-postgresql.sh -i yes

ubuntu-bitbucket-install:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-bitbucket.sh -i yes

ubuntu-bitbucket-launch:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-bitbucket.sh -l

ubuntu-bitbucket-backup:
	# create a package for backup. May need some time. 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-bitbucket_server.sh -i yes
	# back the packge to server. 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-bitbucket_server.sh -p 

ubuntu-confluence-backup:
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-confluence_server.sh -i yes

ubuntu-install-ftp:
	sudo apt update && sudo apt install vsftpd	
	sudo service vsftpd status
	# configure firewall
	sudo ufw allow OpenSSH
	sudo ufw allow 20/tcp
	sudo ufw allow 21/tcp
	sudo ufw allow 40000:50000/tcp
	sudo ufw allow 990/tcp
	sudo ufw enable
	sudo ufw status
	# configure setting for USER
	sudo cp $(SJ_PATH_RESOURCE)/ubuntu18/vsftpd.conf /etc
	sudo service sshd restart
	sudo systemctl restart vsftpd

ubuntu-setup-uniflash:
	cd ./downloads && wget https://dr-download.ti.com/software-development/software-programming-tool/MD-QeJBJLj8gq/7.2.0/uniflash_sl.7.2.0.3893.run
	sudo chmod 777 ./downloads/uniflash_sl.7.2.0.3893.run
	./downloads/uniflash_sl.7.2.0.3893.run

ubuntu-help:
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
