# StartJacinto Project

**startJacinto** project is used to manage the Jacinto6,Jacinto7,Sitara AM62x/AM62Ax SDK, including Ubuntu.

Using this tool can effectively improve your work efficiency , you can develop all the work in one terminal, it's my target to make this tools. 
- Automate repetitive tasks
- Simplify complex tasks.

If you have any suggestions, please share, we can work together to make this tools easier  and smart. Thanks

Below are function list: 
- Manage different SDKs.
- Ppdate images to SD card.
- AUTO download and install SDK.
- Manage develop resouces(tools, patches),etc.
- Yocto environment support.
- Ubuntu Envrionment setup.
- etc.
# Rules
## Variable Name

1. all the global variable: `SJ_*`
2. all the global path    : `SJ_PATH_*`
3. all the internal module: `SJ_PDK_* (PDK example)`

## rules

- Makefile support different model, like psdkra, psdkla. etc. 
- Scripts support. 
- Variable support for different branch, like J721S2/J784S4, etc. 

## Log info
You can check terminal info in `.sj_log`. 
- log info : .sj_log file recoding the command that you are running. 

# usage

## please configure the sdks first

check the `.sj_config_sdks` first. make sure the SDK path.
```
[SDK-0902-j721s2-DRA829]:~/startjacinto> cat .sj_config_sdks 
CONFIG_NAME,PSDKLA_NAME,PSDKRA_NAME
SDK-0902-j721s2-DRA829,09_02_00_05,09_02_00_05
SDK-0901-j721s2-DRA829,09_01_00_06,09_01_00_06
SDK-0900-j721s2-DRA829,09_01_00_00,09_01_00_00
SDK-0901-j784s4-DRA829,09_01_00_06,09_01_00_06
# j721e j7200 j721s2 j784s4, This setting should match with the Soc Name. remove from config. 
SJ_EVM_IP=10.85.130.131
# below is tftp and NFS server ip. 
SJ_SERVER_IP=192.168.10.61
SJ_GIT_SERVER=https://github.com/
SJ_LOG_LEVEL=1
# Yocto Env Setting
SJ_YOCTO_CONFIG_FILE=processor-sdk-linux-09_00_00_06.txt
```
## Start Jacinto Tools

`$ source ui_env_setup_*`

After you run this command, you will see the below contect in your console. Please select one for your environment. Thanks.

![img](https://github.com/fredyzhang2018/startJacinto/blob/master/docs/.pictures/Screenshot%20from%202022-10-23%2011-05-25.png "StartJacinto")

## help info

- make help : basic info for normally used command. 
- make help_all : print all available command and info.
- make print : print startjacinto config/tools path/soc ti.com link.
- make print_config : print tools config. 
- make print_env : print viriable for tools use.
- make print_variable : print viariable use for make rules.
- make log_help : log help info for make rules.
- make check_cmd CMD="*" : check command. 
- make check_cmd_content  CMD="*" : search the cmd content.
- make check_doc_jacinto7  CMD="*": search the jacinto7 docs
- make check_scipts  CMD="*": search the scripts

## TIDL

use below command to get more info:
- make tidl_help

TODO : list the steps to import and run model.

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

use below command to get more info:
- make la_help : hlep info for psdkla.
- make la_help_install : help info for psdkla install. 


### Install the SDK

`make la_install_sdk` : auto install psdkla sdk. 

## Build PSDKRA

use below command to get more info:
- make ra_help : hlep info for psdkla.
- make ra_help_install : help info for psdkla install. 

### Install the PSDKRA

`make ra_install_sdk`

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
## 202405 Release: 30_30_00
1. support color mode for log and make. 
2. make rules clear. 
3. make help clear. 
4. support 0902 sdk. 

## 202401 Release: 30_20_01
1. support sdk git management. you can use `make sdk-git-help`

## 202312 Release: 30_20_00

1. support SDK9.1 J721S2 and J784s4.
2. support nfs: different boot media.

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
