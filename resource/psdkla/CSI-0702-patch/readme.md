CSI-0702-patch-to-mm$ tree
.
├── 0001-default-update-for-RTOS.patch
├── 0002-phy-Distinguish-between-Rx-and-Tx-for-MIPI-D-PHY-wit.patch
├── 0003-dt-bindings-phy-Convert-Cadence-DPHY-binding-to-yaml.patch
├── 0004-phy-cdns-dphy-Prepare-for-Rx-support.patch
├── 0005-phy-cdns-dphy-Allow-setting-mode.patch
├── 0006-phy-cdns-dphy-Add-Rx-support.patch
├── 0007-media-cadence-csi2rx-Add-external-DPHY-support.patch
├── 0008-media-cadence-csi2rx-Soft-reset-the-streams-before-s.patch
├── 0009-media-cadence-csi2rx-Set-the-STOP-bit-when-stopping-.patch
├── 0010-media-cadence-csi2rx-Fix-stream-data-configuration.patch
├── 0011-media-cadence-csi2rx-Add-wrappers-for-subdev-calls.patch
├── 0012-dt-bindings-media-Add-DT-bindings-for-TI-CSI2RX-driv.patch
├── 0013-media-ti-vpe-csi2rx-Add-CSI2RX-support.patch
├── 0014-dmaengine-ti-k3-psil-j721e-Add-entry-for-CSI2RX.patch
├── 0015-arm64-dts-ti-k3-j721e-Add-nodes-to-enable-CSI2.patch
├── 0016-media-cadence-csi2rx-Turn-subdev-power-on-before-sta.patch
├── 0017-HACK-media-ti-vpe-csi2rx-Drain-DMA-when-stopping-str.patch
├── 0018-ti_config_fragments-audio_display.cfg-Enable-TI_CSI2.patch
├── 0019-ub960-pattern-works-well.patch
├── ub960_pattern_start.sh
└── yavta_catch_camera.sh


1. please apply those 19 patches in PSDKLA. 
2. use the new configuration: 
	once you applied those patches. plase run below command on kernel dir:
	```
	./ti_config_fragments/defconfig_builder.sh -t ti_sdk_arm64_release
	```
	then, change the SDK/Rules.make 
	#defconfig
	DEFCONFIG change to ti_sdk_arm64_release_defconfig. 
3. build the kernel , 
	install the dtb and modules to SD filesytem. 
4. How to run? default we have two teminal. 
	1. one teminal run the ub960_pattern_start.sh
		1. configure the ub960
	2. another teminal run the yavta_catch_cameara.sh

Regards, 
Fredy
