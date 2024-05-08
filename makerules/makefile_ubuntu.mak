#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

ubuntu_install_basic: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_basic ... "); 
	$(Q)$(call sj_echo_log, file , "ubuntu: install ubuntu basic", "$(SJ_PATH_SCRIPTS)/ubuntu/install_sw.sh");
	cd $(SJ_PATH_SCRIPTS)/ubuntu/ && ./install_sw.sh -i install_ubuntu_basic
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_basic ... done! "); 

# docker --------------start
ubuntu_docker_install:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_install ... "); 
	sudo apt update
	sudo apt install -y docker.io
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_install ... done! "); 

ubuntu_docker_test:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_test ... "); 
	docker run hello-world
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_test ... done! "); 

ubuntu_install_docker_yocto: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_docker_yocto ... "); 
	docker pull jwidic/ubuntu18.04yocto
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_docker_yocto ... done! "); 
# docker --------------done

ubuntu_install_tftp: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_tftp ... "); 
	$(Q)$(call sj_echo_log, file , "scripts", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-tftp.sh");
	sudo apt-get install tftpd tftp
	cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-tftp.sh -s $(SJ_PATH_PSDKLA) # ./setup-tftp.sh SDK Path. 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_tftp ... done! "); 

ubuntu_install_nfs: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_nfs ... "); 
	$(Q)$(call sj_echo_log, file , "scripts", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-targetfs-nfs.sh");
	sudo apt install nfs-kernel-server nfs-common
	cd $(SJ_PATH_SCRIPTS)/ubuntu && ./setup-targetfs-nfs.sh -p $(SJ_PATH_PSDKLA)/targetNFS
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_nfs ... done! "); 

ubuntu_usbrelay_install: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_install ... "); 
	sudo apt install usbrelay
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_install ... done! "); 

ubuntu_usbrelay_start: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_start ... "); 
	usbrelay HURTM_1=1 HURTM_2=1
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_start ... done! "); 

ubuntu_usbrelay_close: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_close ... "); 
	usbrelay HURTM_1=0 HURTM_2=0
	$(Q)$(call sj_echo_log, info , "1. ubuntu_usbrelay_close ... done! "); 

ubuntu_install_chromium: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_chromium ... "); 
	sudo apt install chromium-browser
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_chromium ... done! "); 

ubuntu_install_geany: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_geany ... "); 
	sudo apt install geany
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_geany ... done! "); 

ubuntu_launch_conky:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_conky ... "); 
	$(Q)$(call sj_echo_log, info , "ubuntu: launch the conky monitor!!!");
	$(Q)if [ -d /sys/bus/platform/devices/coretemp.0/hwmon/hwmon4 ]; then sed -i '/PacTemp/c \$$\{offset 15\}\$$\{font\}\$$\{color FFFDE2\}PacTemp: \$$\{platform coretemp.0/hwmon/hwmon4 temp 1\}°C CPUTemp: \$$\{platform coretemp.0/hwmon/hwmon4 temp 2\}°C HW' $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc; fi
	$(Q)if [ -d /sys/bus/platform/devices/coretemp.0/hwmon/hwmon3 ]; then sed -i '/PacTemp/c \$$\{offset 15\}\$$\{font\}\$$\{color FFFDE2\}PacTemp: \$$\{platform coretemp.0/hwmon/hwmon3 temp 1\}°C CPUTemp: \$$\{platform coretemp.0/hwmon/hwmon3 temp 2\}°C HW' $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc; fi
	conky -c $(SJ_PATH_SCRIPTS)/ubuntu/conkyrc &
	$(Q)$(call sj_echo_log, info , "ubuntu: launch the conky monitor --done!!!");
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_conky ... done! "); 


ubuntu_launch_proxy:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_proxy ... "); 
	@echo "export http_proxy='http://127.0.0.1:8118'"
	@echo "export https_proxy=$(http_proxy)"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_proxy ... done! "); 


ubuntu_jupyter_start: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_jupyter_start ... "); 

	nohup jupyter notebook >/dev/null 2>&1 &
	# ubuntu18 install done!
	$(Q)$(call sj_echo_log, info , "1. ubuntu_jupyter_start ... done! "); 

ubuntu_unixbench_test:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_unixbench_test ... "); 
	$(Q)$(call sj_echo_log, info , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/unixbench.sh !!!");
	cd $(SJ_PATH_SCRIPTS)/ubuntu/ && ./unixbench.sh -i yes -r yes
	$(Q)$(call sj_echo_log, info , "ubuntu: install ubuntu basic $(SJ_PATH_SCRIPTS)/ubuntu/unixbench.sh --done !!!");
	$(Q)$(call sj_echo_log, info , "1. ubuntu_unixbench_test ... done! "); 

ubuntu_cpu_performance:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_cpu_performance ... "); 
	sudo cpufreq-set -r -g performance
	cpufreq-info | grep "current CPU frequency"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_cpu_performance ... done! "); 

ubuntu_cpu_powersave:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_cpu_powersave ... "); 
	sudo cpufreq-set -r -g powersave
	cpufreq-info | grep "current CPU frequency"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_cpu_powersave ... done! "); 


ubuntu_install_krusader:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_krusader ... "); 
	sudo apt-get install krusader
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_krusader ... done! "); 


ubuntu_install_grabserial:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_grabserial ... "); 
	sudo apt-get install grabserial
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_grabserial ... done! "); 

ubuntu_launch_grabserial:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_grabserial ... "); 
	sudo grabserial -v -S -d /dev/ttyUSB0 -t -m "Starting kernel"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_grabserial ... done! "); 

ubuntu_launch_wakeonlan:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_wakeonlan ... "); 
	$(SJ_PATH_JACINTO)/scripts/ubuntu/wakeonlan.sh
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_wakeonlan ... done! "); 

ubuntu_launch_understand:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_understand ... "); 
	/home/fredy/startjacinto/tools/scitools/bin/linux64/understand &
	$(Q)$(call sj_echo_log, info , "1. ubuntu_launch_understand ... done! "); 

ubuntu_jupyter_setup: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_jupyter_setup ... "); 
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
	$(Q)$(call sj_echo_log, info , "1. ubuntu_jupyter_setup ... done! "); 

ubuntu_install_sublime:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_sublime ... "); 
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_sublime ... done! "); 


# TI http://webproxy.ext.ti.com:80  127.0.0.1
ubuntu_proxy_setting:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_setting ... "); 
	$(eval temp_SERVER_IP=http://127.0.0.1)  
	$(eval temp_SERVER_IP_PORT=8118)  
	$(Q)$(call sj_echo_log, file, "setting proxy", "$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)"); 
	$(Q)$(call sj_echo_log, info , "----------------setting bash -----------------------"); 
	$(Q)$(call sj_echo_log, warning, "check current proxy setting ~/.bashrc ... "); 
	$(Q)grep -rni "export"  ~/.bashrc
	$(Q)sed -i "/^export HTTPS_PROXY/c export HTTPS_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^export https_proxy/c export https_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^export HTTP_PROXY/c export HTTP_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^export http_proxy/c export http_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^export ftp_proxy/c export ftp_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^export FTP_PROXY/c export FTP_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)$(call sj_echo_log, debug , "check bash proxy setting now ~/.bashrc ...  ");
	$(Q)grep -rni "export" ~/.bashrc 
	$(Q)$(call sj_echo_log, info , "----------------setting bash ----------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check apt setting /etc/apt/apt.conf ... "); 
	$(Q)grep -rni "Acquire::http::proxy " /etc/apt/apt.conf
	$(Q)sudo sed -i "/^Acquire::http::proxy/c Acquire::http::proxy \"$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)\";" /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, debug , "check proxy setting now .bashrc ");
	$(Q)grep -rni "Acquire::http::proxy " /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  .gitconfig  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check gitconfig setting ~/.gitconfig   ~/git-proxy.sh ... "); 
	$(Q)grep -rni "proxy = " ~/.gitconfig
	$(Q)grep -rni "http"     ~/git-proxy.sh
	$(Q)$(call sj_echo_log, file, "setting apt proxy", "$(temp_SERVER_IP)"); 
	$(Q)sed -i "/^exec \/usr\/bin\/corkscrew/c exec \/usr\/bin\/corkscrew $(temp_SERVER_IP) $(temp_SERVER_IP_PORT) \$$\*" ~/git-proxy.sh
	$(Q)$(call sj_echo_log, debug , "check proxy setting now ~/.gitconfig ");
	$(Q)grep -rni "proxy = " ~/.gitconfig
	$(Q)grep -rni "http" ~/git-proxy.sh
	$(Q)$(call sj_echo_log, info , "----------------setting  gitconfig  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check wget setting ~/.wgetrc  ... "); 
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)sed -i "/^http_proxy=/c http_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)sed -i "/^https_proxy=/c https_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)sed -i "/^ftp_proxy=/c ftp_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)$(call sj_echo_log, debug , "check wget proxy setting ... ");
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       -------------------------"); 
	$(Q)$(call sj_echo_log, debug, "check curl setting ~/.curlrc  ... "); 
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)sed -i "/^proxy=http/c proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.curlrc
	$(Q)$(call sj_echo_log, warning , "check curl proxy setting now ... ");
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, file, "congig curl: ","~/.curlrc"); 
	$(Q)$(call sj_echo_log, file, "congig apt : ","/etc/apt/apt.conf"); 
	$(Q)$(call sj_echo_log, file, "congig git : ","~/.gitconfig   ~/git-proxy.sh"); 
	$(Q)$(call sj_echo_log, file, "congig wget: ","~/.wgetrc"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_setting ... done! "); 

ubuntu_proxy_mask:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_mask ... "); 
	$(Q)$(call sj_echo_log, info , "----------------setting bash -----------------------"); 
	$(Q)$(call sj_echo_log, warning, "check current proxy setting ~/.bashrc ... "); 
	$(Q)grep -rni "export"  ~/.bashrc
	$(Q)sed -i "/^export HTTPS_PROXY/c #export HTTPS_PROXY=" ~/.bashrc
	$(Q)sed -i "/^export https_proxy/c #export https_proxy=" ~/.bashrc
	$(Q)sed -i "/^export HTTP_PROXY/c #export HTTP_PROXY=" ~/.bashrc
	$(Q)sed -i "/^export http_proxy/c #export http_proxy=" ~/.bashrc
	$(Q)sed -i "/^export ftp_proxy/c #export ftp_proxy=" ~/.bashrc
	$(Q)sed -i "/^export FTP_PROXY/c #export FTP_PROXY=" ~/.bashrc
	$(Q)$(call sj_echo_log, debug , "check bash proxy setting now ~/.bashrc ...  ");
	$(Q)grep -rni "export" ~/.bashrc 
	$(Q)$(call sj_echo_log, info , "----------------setting bash ----------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check apt setting /etc/apt/apt.conf ... "); 
	$(Q)grep -rni "Acquire" /etc/apt/apt.conf
	$(Q)sudo sed -i "/^Acquire::http::proxy/c #Acquire::http::proxy" /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, debug , "check proxy setting now .bashrc ");
	$(Q)grep -rni "Acquire::http::proxy" /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  .gitconfig  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check gitconfig setting ~/.gitconfig   ~/git-proxy.sh ... "); 
	$(Q)-grep -rni "proxy =" ~/.gitconfig
	$(Q)-grep -rni "corkscrew"     ~/git-proxy.sh
	$(Q)sed -i "/proxy/d" ~/.gitconfig
	$(Q)sed -i "/gitproxy/d" ~/.gitconfig
	$(Q)$(call sj_echo_log, debug , "check proxy setting now ~/.gitconfig ");
	$(Q)-grep  "proxy =" ~/.gitconfig
	$(Q)-grep  "corkscrew" ~/git-proxy.sh
	$(Q)$(call sj_echo_log, info , "----------------setting  gitconfig  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check wget setting ~/.wgetrc  ... "); 
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)sed -i "/^http_proxy=/c #http_proxy=" ~/.wgetrc
	$(Q)sed -i "/^https_proxy=/c #https_proxy=" ~/.wgetrc
	$(Q)sed -i "/^ftp_proxy=/c #ftp_proxy=" ~/.wgetrc
	$(Q)$(call sj_echo_log, debug , "check wget proxy setting ... ");
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       -------------------------"); 
	$(Q)$(call sj_echo_log, debug, "check curl setting ~/.curlrc  ... "); 
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)sed -i "/^proxy=http/c #proxy=" ~/.curlrc
	$(Q)$(call sj_echo_log, warning , "check curl proxy setting now ... ");
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, file, "congig curl: ","~/.curlrc"); 
	$(Q)$(call sj_echo_log, file, "congig apt : ","/etc/apt/apt.conf"); 
	$(Q)$(call sj_echo_log, file, "congig git : ","~/.gitconfig   ~/git-proxy.sh"); 
	$(Q)$(call sj_echo_log, file, "congig wget: ","~/.wgetrc"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_setting ... done! "); 

ubuntu_proxy_testing:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_testing ..."); 
	$(Q)$(call sj_echo_log, warning, "check aot  ... "); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, file, "congig curl: ","~/.curlrc"); 
	$(Q)$(call sj_echo_log, file, "congig apt : ","/etc/apt/apt.conf"); 
	$(Q)$(call sj_echo_log, file, "congig git : ","~/.gitconfig   ~/git-proxy.sh"); 
	$(Q)$(call sj_echo_log, file, "congig wget: ","~/.wgetrc"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, debug, "check apt  ... "); 
	sudo apt update
	$(Q)$(call sj_echo_log, debug, "check apt  ...  done"); 
	$(Q)$(call sj_echo_log, debug, "check git  ... "); 
	cd $(SJ_PATH_JACINTO) && git clone https://github.com/TexasInstruments/edgeai-modelutils
	$(Q)if [ -d $(SJ_PATH_JACINTO)/edgeai-modelutils ];then \
		rm -rf $(SJ_PATH_JACINTO)/edgeai-modelutils; \
	else  \
		echo "the dic is not exist ,pls check .............................. "; \
	fi
	$(Q)$(call sj_echo_log, debug, "check git  ...  done"); 
	$(Q)$(call sj_echo_log, debug, "check wget  ... "); 
	cd $(SJ_PATH_JACINTO) && wget www.google.com
	$(Q)if [ -f $(SJ_PATH_JACINTO)/index.html ];then \
		rm $(SJ_PATH_JACINTO)/index.html; \
	else  \
		echo "the file is not exist ,pls check .............................. "; \
	fi
	$(Q)$(call sj_echo_log, debug, "check wget  ...  done"); 
	$(Q)$(call sj_echo_log, debug, "check curl  ... "); 
	cd $(SJ_PATH_JACINTO) && curl www.google.com
	$(Q)$(call sj_echo_log, debug, "check curl  ...  done"); 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_testing ... done! "); 

ubuntu_proxy_unmask:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_setting ... "); 
	$(eval temp_SERVER_IP=http://127.0.0.1)  
	$(eval temp_SERVER_IP_PORT=8118)  
	$(Q)$(call sj_echo_log, file, "setting proxy", "$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)"); 
	$(Q)$(call sj_echo_log, info , "----------------setting bash -----------------------"); 
	$(Q)$(call sj_echo_log, warning, "check current proxy setting ~/.bashrc ... "); 
	$(Q)grep -rni "export"  ~/.bashrc
	$(Q)sed -i "/^#export HTTPS_PROXY/c export HTTPS_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^#export https_proxy/c export https_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^#export HTTP_PROXY/c export HTTP_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^#export http_proxy/c export http_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^#export ftp_proxy/c export ftp_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)sed -i "/^#export FTP_PROXY/c export FTP_PROXY=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.bashrc
	$(Q)$(call sj_echo_log, debug , "check bash proxy setting now ~/.bashrc ...  ");
	$(Q)grep -rni "export" ~/.bashrc 
	$(Q)$(call sj_echo_log, info , "----------------setting bash ----------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check apt setting /etc/apt/apt.conf ... "); 
	$(Q)grep -rni "Acquire" /etc/apt/apt.conf
	$(Q)sudo sed -i "/^#Acquire::http::proxy/c Acquire::http::proxy \"$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)\";" /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, debug , "check proxy setting now .bashrc ");
	$(Q)grep -rni "Acquire::http::proxy " /etc/apt/apt.conf
	$(Q)$(call sj_echo_log, info , "----------------setting  apt  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  .gitconfig  -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check gitconfig setting ~/.gitconfig   ~/git-proxy.sh ... "); 
	$(Q)-grep -rni "proxy =" ~/.gitconfig
	$(Q)-grep -rni "http"     ~/git-proxy.sh
	$(Q)sed -i "/^\[core\]/a\ \tgitproxy = $(HOME)\/git-proxy.sh"    ~/.gitconfig
	$(Q)sed -i "/^\[http\]/a\ \tproxy = $(temp_SERVER_IP):$(temp_SERVER_IP_PORT)"    ~/.gitconfig
	$(Q)sed -i "/^\[https\]/a\ \tproxy = $(temp_SERVER_IP):$(temp_SERVER_IP_PORT)"    ~/.gitconfig
	$(Q)sed -i "/^#exec \/usr\/bin\/corkscrew/c exec \/usr\/bin\/corkscrew $(temp_SERVER_IP) $(temp_SERVER_IP_PORT) \$$\*" ~/git-proxy.sh
	$(Q)$(call sj_echo_log, debug , "check proxy setting now ~/.gitconfig ");
	$(Q)grep -rni "proxy = " ~/.gitconfig
	$(Q)grep -rni "http" ~/git-proxy.sh
	$(Q)$(call sj_echo_log, info , "----------------setting  gitconfig  ------------------------- done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       -------------------------"); 
	$(Q)$(call sj_echo_log, warning, "check wget setting ~/.wgetrc  ... "); 
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)sed -i "/^#http_proxy=/c http_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)sed -i "/^#https_proxy=/c https_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)sed -i "/^#ftp_proxy=/c ftp_proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.wgetrc
	$(Q)$(call sj_echo_log, debug , "check wget proxy setting ... ");
	$(Q)grep -rni "proxy" ~/.wgetrc
	$(Q)$(call sj_echo_log, info , "----------------setting  wget       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       -------------------------"); 
	$(Q)$(call sj_echo_log, debug, "check curl setting ~/.curlrc  ... "); 
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)sed -i "/^#proxy=/c proxy=$(temp_SERVER_IP):$(temp_SERVER_IP_PORT)" ~/.curlrc
	$(Q)$(call sj_echo_log, warning , "check curl proxy setting now ... ");
	$(Q)grep -rni "proxy" ~/.curlrc
	$(Q)$(call sj_echo_log, info , "----------------setting  curl       ------------------------ done!"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, file, "congig curl: ","~/.curlrc"); 
	$(Q)$(call sj_echo_log, file, "congig apt : ","/etc/apt/apt.conf"); 
	$(Q)$(call sj_echo_log, file, "congig git : ","~/.gitconfig   ~/git-proxy.sh"); 
	$(Q)$(call sj_echo_log, file, "congig wget: ","~/.wgetrc"); 
	$(Q)$(call sj_echo_log, file, "congig bash: ","~/.bashrc"); 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_proxy_setting ... done! "); 


ubuntu_install_shadowsocks:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_shadowsocks ... "); 
	snap install shadowsocks-electron
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_shadowsocks ... done! "); 

ubuntu_docker_ubuntu14: check_paths_PSDKLA
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_ubuntu14 ... "); 
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123 or xxx"
	docker run -t -i -v $(SJ_PATH_JACINTO):$(SJ_PATH_JACINTO) jwidic/ubuntu:14.04yocto /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_ubuntu14 ... done! "); 

ubuntu_docker_ubuntu18: check_paths_PSDKLA
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_ubuntu18 ... "); 
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123"
	# docker run -t -i -v $(SJ_PATH_JACINTO):$(SJ_PATH_JACINTO) jwidic/ubuntu18.04yocto  /bin/bash
	docker run -t -i -v $(SJ_PATH_JACINTO):$(SJ_PATH_JACINTO) ubuntu18.04:v3  /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_ubuntu18 ... done! "); 

ubuntu_docker_gpu_setup: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_GPU_setup ... "); 
	sudo apt install nvidia-container-runtime
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_GPU_setup ... done"); 

ubuntu_docker_basic_setup: 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_basic_setup ... "); 
	sudo apt install bash-completion
	$(Q)$(call sj_echo_log, info , "1. ubuntu_docker_basic_setup ... done!"); 

ubuntu_install_pcan_tools:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_pcan_tools ... "); 
	cd $(SJ_PATH_JACINTO)/tools/ && git clone ssh://git@10.85.130.233:7999/psdkra/peak-linux-driver-8.9.3.git
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3 && make all && sudo make install && sudo modprobe pcan
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_pcan_tools ... done! "); 

# install opecv: two pamerater needed
SJ_OPENCV_PATH= $(SJ_PATH_JACINTO)/sdks
SJ_OPENCV_VERSION = 4.1.0
ubuntu_install_opencv:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_opencv ... "); 
	$(Q)$(call sj_echo_log, help , "# install opecv: two pamerater needed  "); 
	$(Q)$(call sj_echo_log, help , "SJ_OPENCV_PATH", "$(SJ_OPENCV_PATH)"); 
	$(Q)$(call sj_echo_log, help , "SJ_OPENCV_VERSION", "$(SJ_OPENCV_VERSION)"); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-opencv.sh"); 
	$(SJ_PATH_SCRIPTS)/ubuntu/setup-opencv.sh $(SJ_OPENCV_PATH) $(SJ_OPENCV_VERSION)
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_opencv ... done! "); 

ubuntu_ssh_agent:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_ssh_agent ... "); 
	echo "ssh-agent -s && ssh-agent bash && ssh-add ~/.ssh/id_rsa"
	$(Q)$(call sj_echo_log, info , "1. ubuntu_ssh_agent ... done! "); 

ubuntu_confluence_install:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_confluence_install ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-confluence.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-confluence.sh -i yes
	$(Q)$(call sj_echo_log, info , "1. ubuntu_confluence_install ... done! "); 

ubuntu_confluence_launch:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_confluence_launch ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-confluence.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-confluence.sh -l
	$(Q)$(call sj_echo_log, info , "1. ubuntu_confluence_launch ... done! "); 

ubuntu_postgresql_install:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_postgresql_install ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-postgresql.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-postgresql.sh -i yes
	$(Q)$(call sj_echo_log, info , "1. ubuntu_postgresql_install ... done! "); 

ubuntu_bitbucket_install:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_install ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-bitbucket.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-bitbucket.sh -i yes
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_install ... done! "); 

ubuntu_bitbucket_launch:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_launch ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-bitbucket.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/setup-bitbucket.sh -l
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_launch ... done! "); 

ubuntu_bitbucket_backup:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_backup ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-bitbucket_server.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-bitbucket_server.sh -i yes
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-bitbucket_server.sh -p 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_bitbucket_backup ... done! "); 

ubuntu_confluence_backup:
	$(Q)$(call sj_echo_log, info , "1. la_install_help ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/ubuntu/setup-confluence_server.sh"); 
	cd $(SJ_PATH_SCRIPTS) && ./ubuntu/setup/backup-confluence_server.sh -i yes
	$(Q)$(call sj_echo_log, info , "1. la_install_help ... done! "); 

ubuntu_install_ftp:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_ftp ... "); 
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
	$(Q)$(call sj_echo_log, info , "1. ubuntu_install_ftp ... done! "); 

ubuntu_setup_uniflash:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_setup_uniflash ... "); 
	cd ./downloads && wget https://dr-download.ti.com/software-development/software-programming-tool/MD-QeJBJLj8gq/7.2.0/uniflash_sl.7.2.0.3893.run
	sudo chmod 777 ./downloads/uniflash_sl.7.2.0.3893.run
	./downloads/uniflash_sl.7.2.0.3893.run
	$(Q)$(call sj_echo_log, info , "1. ubuntu_setup_uniflash ... done! "); 

ubuntu_help:
	$(Q)$(call sj_echo_log, info , "1. ubuntu_help ... "); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_basic"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_chromium"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_docker_yocto" ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_ftp"          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_geany"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_grabserial"   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_krusader"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_nfs"          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_opencv"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_pcan_tools"   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_shadowsocks"  ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_install_tftp"         ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_bitbucket_backup"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_bitbucket_install"    ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_bitbucket_launch"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_confluence_backup"    ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_confluence_install"   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_confluence_launch"    ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_cpu_performance"      ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_cpu_powersave"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_docker_install"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_docker_test"          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_jupyter_setup"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_jupyter_start"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_launch_conky"         ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_launch_grabserial"    ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_launch_proxy"         ,"export proxy to console ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_launch_understand"    ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_launch_wakeonlan"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_postgresql_install"   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_proxy_setting"        ,"setting proxy... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_proxy_mask"           ,"musk the proxy setting... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_proxy_unmask"         ,"unmusk the proxy setting... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_setup_uniflash"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_ssh_agent"            ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_unixbench_test"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_usbrelay_close"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_usbrelay_install"     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_usbrelay_start"       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_docker_gpu_setup"     ,"docker gpu env setup...  "); 
	$(Q)$(call sj_echo_log, help , "ubuntu_docker_basic_setup"     ,"docker basic command setup...  "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. ubuntu_help ... done! ");  
	