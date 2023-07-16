# StartJacinto Project

startJacinto project is used to manage the Jacinto6 and Jacinto7 SDK, include Ubuntu.

- manage different SDKs.
- update image to SD card.
- AUTO download and install SDK.
- manage develop resouces(tools, patches),etc.
- Yocto environment support.
- Ubuntu Envrionment Support
- etc.
  If you have any suggestions, please share, we can work together to make this tools eaiser , smart. Thanks.

# Rules

## Variable Name

1. all the global variable: `SJ_*`
2. all the global path    : `SJ_PATH_*`
3. all the internal module: `SJ_PDK_* (PDK example)`

## rules

```
---env     --------------- makerules   
---scripts ---------------
---patch   ---------------  
```

# usage

## please configure the sdk path first

check the env_setup_jacinto.sh first. make sure the SDK path.

## Start Jacinto Tools

`$ source ui_env_setup_*`

After you run this command, you will see the below contect in your console. Please select one for your environment. Thanks.

![img](https://github.com/fredyzhang2018/startJacinto/blob/master/docs/.pictures/Screenshot%20from%202022-10-23%2011-05-25.png "StartJacinto")

## run command to build the system

Print variable :
`make print_all       print_config    print_env   print_variable`

## TIDL

### Inference and import

Fredy Tools model zoos support import the images list. Two model

1. input_imges
   1. this mode, need to create a dictory on model dictory.
   2. startjacinto tools : TIDL makefile set :  SJ_TIDL_INFERENCE_CONFIG_LIST as no.
   3. EVM inference should set to no also .
2. input_imges_list
   1. if  the dictory of input_images_list is exist, then model will import follow the list \.
   2. Startjacinto tools : TIDL makefile setting : SJ_TIDL_INFERENCE_CONFIG_LIST as yes
   3. EVM inference scripts should set to : yes .
3. check the trace /feature map ,etc
   1. tidl-model-check-feature-map
   2. tidl-model-check-inference-trace

- Import the model and run on pc, you should check the makefile_tidl.mk for configure.
  `tidl-model-import-inference-run`
- imnet onnx example

  `tidl-model-onnx-imnet`
- set up the model to sd card over scp: `tidl-model-sd-model-setup`

### Run Inference on PC

1. Import and run inference on PC: `tidl-model-import-inference-run`

### Run Inference on EVM

tidl-model-inference-run-evm    :  Run inference on EVM
tidl-model-run-on-evm-setup     :  evm run command
tidl-model-zoo-download         :  Model  download

1. SD card model setup: `tidl-model-sd-model-setup`
2. Run inference on EVM: `tidl-model-inference-run-evm`
3. Compare the result: `tidl-model-check-inference-trace`

### TIDL BULD

* Download and setup :  `make tidl-src-download-setup `
* Download and setup adds on package: `tidl-src-addon-packages`
* Build the TIDL dependent: `tidl-src-build-dependent`
* Build the TIDL SRC: `tidl-src-build-pc`
* Build the TIDL SRC: `tidl-src-build-pc`

```
tidl-src-addon-packages  # install the protobuf  FlatBuffer FlatBuffer
tidl-src-build-evm       # build all TIDL Runtime
tidl-src-build-pc        # build all TIDL for PC emulation
tidl-src-download-setup  # Download Repo
tidl-src-build-dependent # graphviz build 
```

## Edge AI

- ra-edgeai               : build the edgeai.
- ra-edgeai-install       : install teh edgeai to sdk.
- ra-edgeai-scrub         : clean the edgeai build.
- ra-sdk-edgeai            : setup the SDK for edgeai
- ra-nfs-linux-fs-install-edgeai

### Steps to setup edge AI SDK.

Method 1 :  use the edge ai filesystem, this already setuped .

Method 2 :  follow the steps: [https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-sk-tda4vm/08_05_00/exports/docs/index.html](https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-sk-tda4vm/08_05_00/exports/docs/index.html)

- Setup the PSDKLA
- Setup the PSDKRA
- Build the edgeAI : ra-sdk-edgeai
- build the edgeai:  ra-edgeai
- PC 👍

  ```shell
  /media/<user-name>/rootfs/opt#git clone --single-branch --branch master git://git.ti.com/edgeai/edge_ai_apps.git
  /media/<user-name>/rootfs/opt/edge_ai_apps#./setup_script.sh
  /media/<user-name>/rootfs/opt/edge_ai_apps#./download_models.sh --recommended
  ```
- Setup the edgeai: ra-nfs-linux-fs-install-edgeai
- Setup the edgeai: ra-edgeai-install
- boot the board :  only need to run once 👍 setup_script.sh

### Run the Demo

```shell
cd /opt/edge_ai_apps
source ./init_scripts.sh. 
```

Running :Gst treamer demo :  [https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-sk-tda4vm/08_05_00/exports/docs/end_to_end_gstreamer_demos.html](https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-sk-tda4vm/08_05_00/exports/docs/end_to_end_gstreamer_demos.html%E2%80%B8)

## BOOT FLow

### Solution 1:  SPL - Linux

Default SDK.

### Solution 2: SBL - Linux (no uboot)

please notice, below command need to update sdk makefile

1. sbl-bootimage-sd
2. sbl-vision_apps-bootimage
3. sbl-linux-bootimage
4. make sbl-sd-bootimage-install

### Solution3 : SBL  --> SPL --> uboot --> Linux

`ROM --> R5 SBL --> SPL  --> uboot -->  A72 ATF --> Kernel`

1. make mcusw-sbl-boot-u-boot      # setting mode: deveopment, optimized is for quick boot.
2. make mcusw-sd-sbl-boot-u-boot # setting mode.

### OSPI Flash

SDK8.2 Test : TFTP boot.

For Non HS board.  You can boot from DFU , using the K3 conf NFS boot.

1. sbl-ospi-bootimage-install-tftp
2. Flash the image : tftp --> RTOS

   ```

   dhcp
   setenv serverip 10.85.130.60 
   sf probe 
   tftp ${loadaddr} sbl_cust_img_mcu1_0_release.tiimage
   sf update $loadaddr 0x0     $filesize
   tftp ${loadaddr} tifs.bin 
   sf update $loadaddr 0x80000 $filesize
   tftp ${loadaddr} can_boot_app_mcu_rtos_mcu1_0_release_ospi.appimage
   sf update $loadaddr 0x100000  $filesize 
   tftp ${loadaddr} lateapp1
   sf update $loadaddr 0x1fc0000  $filesize 
   tftp ${loadaddr} lateapp2
   sf update $loadaddr 0x27c0000  $filesize 
   tftp ${loadaddr} atf_optee.appimage
   sf update $loadaddr 0x1c0000  $filesize 
   tftp ${loadaddr} tikernelimage_linux.appimage
   sf update $loadaddr 0x7c0000  $filesize 
   tftp ${loadaddr} tidtb_linux.appimage
   sf update $loadaddr 0x1ec0000  $filesize 
   # OSPI PYH Pattern 
   tftp ${loadaddr} nor_spi_patterns.bin 
   sf update $loadaddr 0x3fe0000  $filesize 
   ```
3. Flash the psdkla sdk.

   ```
   # Linux 
   dhcp
   setenv serverip 10.85.130.60 
   sf probe
   tftp ${loadaddr} tiboot3.bin
   sf update $loadaddr 0x0 $filesize
   tftp ${loadaddr} tispl.bin
   sf update $loadaddr 0x80000 $filesize
   tftp ${loadaddr} u-boot.img
   sf update $loadaddr 0x280000 $filesize
   tftp ${loadaddr} sysfw.itb
   sf update $loadaddr 0x6C0000 $filesize

   ```
4. HS board tftp : make hs-ospi-bootimage-install-tftp.

## Security

[Markdown-Security](./docs/jacinto7/jacinto7_module_security.md)

### Keywriter

1. install the key writer.

SOC Analysis:  make ra-hs-check-uart-boot-log  python analysis the security chip log. Thanks.

### SBL build

Tested on SDK8.2. it works well. Before build, You should set the chip silicon.

`vision_apps/vision_apps_build_flags.mak`

```
J7ES_SR?=1_1
```

Then follow the below step to generate the hs image: SBL/app/can boot app.

SBL-CAN BOOT APP --> LINUX

1. `make hs-sbl-bootimage-sd`
2. `hs-sbl-vision-apps-bootimage`
3. hs-sbl-linux-bootimage
4. `hs-sd-sbl-bootimage-install-sd`

Combined Image:

1. hs-sbl-linux-combined-bootimage
2. hs-sd-sbl-combined-bootimage

## Build PSDKLA

Simalar as SDK.

```
make la-*
```

### Install the SDK

`make la-install-sdk`

## Build PSDKRA

Similar as SDK.

```
make ra-*
```

### Install the PSDKRA

`make ra-install-sdk`

### minifest

#### Manifest Setup

```
	manifest-update-local-repo    : update repo from remote to local(Internal using)"
	manifest-repo-init            : init repo in SJ_PATH_PSDKRA"
	manifest-repo-sync            : Sync the repo"
	manifest-install              : install the repo minifest to sdks  "
```

#### Manifest Build

1. Enable PSDK RTOS for Linux+RTOS mode (NOTE: this is default and documented here for reference only)
   Edit `tiovx/build_flags.mak` and modify below variable, `BUILD_LINUX_A72?=yes`
2. Build PSDK RTOS by doing below in "vision_apps" `make sdk -j8`
3. Copy application related files to target filesystem in SD card, by doing below in "vision_apps"
   `make linux_fs_install_sd`
   OR
   `make linux_fs_install_sd PROFILE=debug` (to copy the debug versions to the filesystem)
4. Copy test data files to SD card (required for some demos, typically needs to be done once)
   `make linux_fs_install_sd_test_data`

### install

```
    ra-install-dependencies           : install sdk dependencies
    ra-ccs-setup-steps                : print the ccs setup steps
    ra-install-targetfs               : install the PSDKLA filesytem to PSDKRA
    ra-install-sdk                    : Install SDKs
    ra-install-sdk-addon              : Install the addon package. 
    ra-install-dataset                : Install the dataset
```

### SD card setup

```
    ra-sd-help
    ra-sd-mk-partition-method                   : print SD card partition method.
    ra-sd-mk-partition                          : make sd card parttion
    ra-sd-install-rootfs                        : install filesystem to SD card
    ra-sd-install-auto-ti-data                  : install the auto ti data
    ra-sd-linux-fs-install-sd               　　: install images to SD card
    ra-sd-linux-fs-install-sd-debug             : install the debug version images to SD card
    ra-sd-linux-fs-install-sd                   : install the auto ti data
    ra-sd-linux-fs-install-sd-test－data         : --> internal using
```

## OpenVX

### Tutorial

```
tiovx_tutorial_exe_build # build the tiovx tutorial 
tiovx_tutorial_exe_run   # run the tutorial app

```

### Pytiovx

usecase

```
# Kernel 
tiovx-pyovx-generate-new-kernel

# usecase
tiovx-pyovx-generate-new-app
tiovx-pyovx-generate-new-app-run
```

## Yocto Support

### local build

build yocto use below command:

1. la-yocto-install --> install the yocto env.
2. la-yocto-build   --> yocto build.

### docker yocto support.

- Docker setup on Ubuntu
  1. run `ubuntu-docker-install`           --> docker install
  2. run `ubuntu-docker-test`              --> docker testing
  3. run `ubuntu-install-docker-yocto`     --> install docker ubuntu18 image
- start docker
  1. run `ubuntu-docker-yocto-ubuntu18-j7` --> docker ubuntu18 start.
  2. run `su fredy`                        --> password (123)
  3. run `cd startJacinto`
  4. run `make la-yocto-install`
  5. run `make la-yocto-build`

## Gateway Demo

1. PCAN tools setup ： `make ubuntu-install-pcan-tools`
2. Build the demo:     `make gateway-build`
3. Run the demo:

# Remote Environment

You can use the TDA4 EVM board to setup a remote debug envrionment. More details, please refer to below:
**Hardware**: USBRELAY to power-on and power-off the baord.
**K3-Switch Tool**: boot the board  with different boot mode over the DFU.

## USBRELAY

I am using the USBRELAY and tested on my envrionment.
Install the driver: `make ubuntu-install-usbrelay`

### USBRELAY using

1. power-on  the board: `make ubuntu-usbrelay-start`
2. power-off the board: `make ubuntu-usbrelay-close`

## k3 switch Tool

k3 bootswitch tools introduction

1. USB connect to Linux PC
2. main_uart connect to Linux PC
3. * j721e-evm settings  => SW8 = 1000 0000      SW9 = 0010 0000      SW3 = 0101 00 1010
4. USB replay setup:  cp k3bootswitch.conf ~/HOME/.config/
   (usbrelay HURTM_1=0 HURTM_2=0 && sleep 0.5 && usbrelay HURTM_1=1 HURTM_2=1 && sleep 0.1) >/dev/null 2>&1

install
`sudo apt-get install dfu-util`
boot in differenct mode

```
	sudo ./dfu-boot.sh --j721e-evm --bootmode mmc
	sudo ./dfu-boot.sh --j721e-evm --bootmode emmc
	sudo ./dfu-boot.sh --j721e-evm --bootmode ospi
	sudo ./dfu-boot.sh --j721e-evm --bootmode uart
    sudo ./dfu-boot.sh --j721e-evm --bootmode noboot
```

mount the sd/emmc

```
    sudo ./dfu-boot.sh --j721e-evm --mount 0 //eMMC
	sudo ./dfu-boot.sh --j721e-evm --mount 1 //SD
```

## NFS

NFS Boot

Resource : [[https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1165196/tda4vm-q1-how-to-use-nfs-on-tda4vm?tisearch=e2e-sitesearch&amp;keymatch=tda4vm%25252520nfs%25252520boot#](https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1165196/tda4vm-q1-how-to-use-nfs-on-tda4vm?tisearch=e2e-sitesearch&keymatch=tda4vm%25252520nfs%25252520boot#%E2%80%B8)](https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1165196/tda4vm-q1-how-to-use-nfs-on-tda4vm?tisearch=e2e-sitesearch&keymatch=tda4vm%25252520nfs%25252520boot#](https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1165196/tda4vm-q1-how-to-use-nfs-on-tda4vm?tisearch=e2e-sitesearch&keymatch=tda4vm%25252520nfs%25252520boot#%E2%80%B8))

need to
install the tftp and nfs server first.

```
make ubuntu-install-tftp
make ubuntu-install-nfs
```

# PSDKLA

sdk setup
scripts setup the basic environment.

```

nfs-help  
# help
nfs-setup-psdkla             # reference the sdk to setup the environment. 
nfs-setup-minicom-psdkla     # open the minicom port to recevie the uart data. 
nfs-setup-uboot-img          # update host tools boot partition images for current sdk. 
```

SDK 0804: test works well. Thannks.

PSDKRA

```

make nfs-setup-psdkra
make nfs-setup-minicom   # this command will setup the uboot env and boot PSDKRA from NFS automatically. 

# Below two command for update NFS targetfs.  

make ra-nfs-linux-fs-install # update nfs linux fs. 

```

0805 Version ：

```
issue on TIDL . 
```

# Yocto

## Yocto Ubuntu14

Build psdk0304 yocto

```
export INSTALL_DIR=/home/fredy/startjacinto/sdks1/ti-processor-sdk-linux-automotive-dra7xx-evm-03_04_00_03 
cd $INSTALL_DIR
export PATH=${INSTALL_DIR}/bin:$PATH
export PATH=/home/fredy/startjacinto/sdks1/ti-processor-sdk-linux-automotive-dra7xx-evm-03_04_00_03/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin:$PATH
cd yocto-layers
./build-core-sdk.sh dra7xx-evm

```

# Ubuntu

## ubuntu install opencv

`make ubuntu-install-opencv`

# Release notes

## 202307 Release : 30_10_00

1. suppot am6x device.
2. support TDA4VH /VM eco etc.
3. update useful scripts.

## 202209 1st release : 30_00_00

1. Gateway Demo support.
2. Support New UI.
3. Support J721S2.
4. Tested SDK8.4

## 202108 1st release : 20_01_00

1. PSDKLA & PSDKRA supported.

## 202108 1st release : 20_00_00

1. Yocto
   - yocto build support.
   - yocto docker env setup.
2. env restructure.
3. ubuntu support.

## 202105 1st release : 10_00_00

- support PSDKLA 0703 and PSDKRA0703.

# License

[MIT License](./docs/LICENSE)
