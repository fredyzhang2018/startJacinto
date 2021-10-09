# This file is used to describe the usage StartJaconto Project

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
`$ source env_setup_*`
```
############################################################################################
#                                                                                          #
#                       Welcome to StartJacinto Tool                                 #
#                                                                                          #
############################################################################################
please help to give your option:
 1. SDK 0800 for TDA4VM/DRA829 
    LA: ti-processor-sdk-linux-j7-evm-08_00_00_08  
    RA: ti-processor-sdk-rtos-j721e-evm-08_00_00_12  
 2. SDK 0703 for TDA4VM/DRA829  
    LA: ti-processor-sdk-linux-j7-evm-07_03_00_05  
    RA: ti-processor-sdk-rtos-j721e-evm-07_03_00_07  
plase input your selection: 1
--------------------------------------------------------------------------------------------
############################################################################################
#                                                                                          #
#                       starting Jacinto7_08_00 , Happy Debugging                          #
#                                                                                          #
############################################################################################
```
## run command to build the system
Print variable : 
    `make print_all       print_config    print_env   print_variable`

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

### install 
```
    ra-install-dependencies           : install sdk dependencies
    ra-ccs-setup-steps                : print the ccs setup steps
    ra-install-targetfs               : install the PSDKLA filesytem to PSDKRA
    ra-install-sdk                    : Install SDKs
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
```
1. USB connect to Linux PC
2. main_uart connect to Linux PC
3. * j721e-evm settings  => SW8 = 1000 0000      SW9 = 0010 0000      SW3 = 0101 00 1010
4. USB replay setup:  cp k3bootswitch.conf ~/HOME/.config/
(usbrelay HURTM_1=0 HURTM_2=0 && sleep 0.5 && usbrelay HURTM_1=1 HURTM_2=1 && sleep 0.1) >/dev/null 2>&1
```
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

# Ubuntu

## ubuntu install opencv
`make ubuntu-install-opencv`

# Release notes
## 202110 1st release : 20_02_00
1. Gateway Demo support. 
2. restructure all the variables. 

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



