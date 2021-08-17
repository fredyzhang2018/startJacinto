# This file is used to describe the usage StartJaconto Project

startJacinto project is used to manage the Jacinto6 and Jacinto7 SDK. 

- manage different SDKs. 
- update image to SD card. 
- AUTO download and install SDK.
- manage develop resouces(tools, patches),etc. 
- Yocto environment support.
- Ubuntu Envrionment Support 
- etc.  
If you have any suggestions, please share, we can work together to make this tools eaiser , smart. Thanks. 


# usage
## please configure the sdk path first
check the env_setup_jacinto.sh first. make sure the SDK path. 

## Start Jacinto Tolls
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

## Yocto Support
### local build
build yocto use below command:
1. la-yocto-install --> install the yocto env. 
2. la-yocto-build   --> yocto build. 
### docker yocto support. 
1. Docker setup on Ubuntu
    a. run `ubuntu-docker-install`           --> docker install
    b. run `ubuntu-docker-test`              --> docker testing 
    c. run `ubuntu-install-docker-yocto`     --> install docker ubuntu18 image
2. start docker 
    a. run `ubuntu-docker-yocto-ubuntu18-j7` --> docker ubuntu18 start.
    b. run `su fredy`                        --> password (123)
    c. run `cd startJacinto`
    d. run `make la-yocto-install`
    e. run `make la-yocto-build`

# Release notes
## 202108 1st release : 20_00_00
1. Yocto
    - yocto build support. 
    - yocto docker env setup.
2. env restructure. 
3. ubuntu support. 

## 202105 1st release : 10_00_00
- support PSDKLA 0703 and PSDKRA0703. 



