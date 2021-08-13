#
# Ubuntu command
#
# Edit this file to suit your specific build needs
#

# docker 
ubuntu-docker-install:
	sudo apt update
	sudo apt install -y docker.io

ubuntu-docker-test:
	docker run hello-world


ubuntu-install-docker-yocto: 
	docker pull jwidic/ubuntu_18.04_yocto


ubuntu-docker-yocto-ubuntu18-j7: check_paths_PSDKLA
	$(Q$(ECHO) "please below account:"
	$(Q$(ECHO) "   USER: fredy"
	$(Q$(ECHO) "   PWD:  123"
	docker run -t -i -v $(jacinto_PATH):$(jacinto_PATH) ubuntu18_yocto_v1  /bin/bash
	$(Q$(ECHO) "   Yocto build done, happy using !!!"


