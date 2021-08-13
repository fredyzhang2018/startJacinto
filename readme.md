# This file is used to describe the usage StartJaconto Project

startJacinto project is used to manage the Jacinto6 and Jacinto7 SDK. 

-  manage different SDK. 
-  update image to SD card. 
-  AUTO download and install SDK.
- manage develop resouces
- yocto environment support. 
- etc.  
If you have any suggestions, please share, we can work together to make this tools eaiser , smart. Thanks. 


# usage
## please configure the sdk path first
Below env is in env_setup_jacinto_xxxx: 
- jacinto_PATH=**/home/fredy/install/startJacinto**
- PSDKRA_PATH=**/home/fredy/j7/ti-processor-sdk-rtos-j721e-evm-07_02_00_06**
- PSDKLA_PATH=**/home/fredy/j7/ti-processor-sdk-linux-j7-evm-07_02_00_07**
## source SDK version

`$ source env_setup_*`
## run command to build the system
Print variable : 
    `make print_all       print_config    print_env   print_variable`

## Build PSDKLA
Simalar as SDK. 
```
make la-*
```
## Build PSDKRA
Similar as SDK. 
```
make ra-*
```
## Yocto 
1. build yocto use below command:
    - la-yocto-install --> install the yocto env. 
    - la-yocto-build   --> yocto build. 
2. docker yocto support. 
    - setup the yocto
        1. ubuntu-docker-install           --> docker install
        2. ubuntu-docker-test              --> docker testing 
        3. ubuntu-install-docker-yocto     --> install docker ubuntu18 environment
        4. ubuntu-docker-yocto-ubuntu18-j7 --> build the yocto in docker

# Release notes


## 202105 1st release : 10_00_00
- support PSDKLA 0703 and PSDKRA0703. 

## 202108 1st release : 20_00_00
1. Yocto
    - yocto build support. 
    - yocto docker env setup.
2. env restructure. 
3. ubuntu support. 


