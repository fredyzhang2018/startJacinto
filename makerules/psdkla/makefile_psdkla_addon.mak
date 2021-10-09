#
# Utility makefile to show important make targets
#
SD_BOOT=/media/`whoami`/BOOT
SD_BOOT1=/media/`whoami`/boot
SD_ROOTFS=/media/`whoami`/rootfs


linux-dtbs-sd-install:
	@echo =======================================
	@echo     Installing the Linux Kernel DTBs to SD rootfs
	@echo =======================================
	@if [ ! -d $(SD_ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	sudo install -d $(SD_ROOTFS)/boot
	@for DTB in      ti/k3-j721e-common-proc-board.dtb     ti/k3-j721e-proc-board-tps65917.dtb     ti/k3-j721e-common-proc-board-infotainment.dtbo     ti/k3-j721e-eaik.dtb ti/k3-j721e-vision-apps.dtbo ti/k3-j721e-edgeai-apps.dtbo ti/k3-j721e-eaik-csi2-ov5640.dtbo ti/k3-j721e-eaik-rpi-cam-imx219.dtbo ; do \
		sudo install -m 0644 $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/dts/$$DTB $(SD_ROOTFS)/boot/; \
	done

jailhouse_install_sd:
	@echo ================================
	@echo      Installing jailhouse
	@echo ================================
	@echo " test $(SD_ROOTFS) "
	@if [ ! -d $(SD_ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	@cd board-support/extra-drivers; \
	cd `find . -maxdepth 1 -name "jailhouse*" -type d`; \
	make ARCH=$(JH_ARCH) KDIR=${LINUXKERNEL_INSTALL_DIR} DESTDIR=$(SD_ROOTFS) INSTALL_MOD_STRIP=$(INSTALL_MOD_STRIP) prefix=/usr install


linux_install_sd: 
	@echo ===================================
	@echo     Installing the Linux Kernel
	@echo ===================================
	@echo " test $(SD_ROOTFS) "
	@if [ ! -d $(SD_ROOTFS) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	sudo install -d $(SD_ROOTFS)/boot
	sudo install $(LINUXKERNEL_INSTALL_DIR)/arch/arm64/boot/Image $(SD_ROOTFS)/boot
	sudo install $(LINUXKERNEL_INSTALL_DIR)/vmlinux $(SD_ROOTFS)/boot
	sudo install $(LINUXKERNEL_INSTALL_DIR)/System.map $(SD_ROOTFS)/boot
	$(MAKE) -C $(LINUXKERNEL_INSTALL_DIR) ARCH=arm64 CROSS_COMPILE=$(CROSS_COMPILE) INSTALL_MOD_PATH=$(SD_ROOTFS) INSTALL_MOD_STRIP=$(INSTALL_MOD_STRIP) modules_install


