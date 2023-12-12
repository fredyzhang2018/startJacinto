# SD Card

## Step1: env setting

```
[SDK-0901-j721s2-DRA829]:~/Startjacinto> source ui_env_setup_jaicinto.sh 
```

Select the SDK that you wanted.

## Step2 make SD parition.

```
[SDK-0901-j721s2-DRA829]:~/Startjacinto> make ra-sd-mk-partition
sudo /home/fredy/Startjacinto/scripts/mk-linux-card-psdkra.sh
[sudo] password for fredy: 
-----------------mk sd PSDKRA partition ------------------
Work path: /home/fredy/Startjacinto
***************************************************************
Usage: /home/fredy/Startjacinto/scripts/mk-linux-card-psdkra.sh <drive>
E.g: /home/fredy/Startjacinto/scripts/mk-linux-card-psdkra.sh /dev/sdx
***************************************************************
Start the process
/dev/sda3  1048608768 4000796671 2952187904  1.4T Linux filesystem
Disk /dev/sdc: 59.48 GiB, 63864569856 bytes, 124735488 sectors
/dev/sdc1       32768 124735487 124702720 59.5G  7 HPFS/NTFS/exFAT
>>>>>Please input the SD Device:/dev/sdc
SD_DEVICE: /dev/sdc
DEVICE_YES: y
>>>>>Please sure to y:y
 make partition starting
fredy: /dev/sdc
-- Main device is: /dev/nvme0n1p6
The drive /dev/sdc will be erased and re-formated
Do you want to continue (y/n)? [N]: 
y
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.388722 s, 2.7 MB/s

Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xba682fe2.

Command (m for help): Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): Partition number (1-4, default 1): First sector (2048-124735487, default 2048): Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-124735487, default 124735487): 
Created a new partition 1 of type 'Linux' and of size 128 MiB.

Command (m for help): Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): Partition number (2-4, default 2): First sector (264192-124735487, default 264192): Last sector, +/-sectors or +/-size{K,M,G,T,P} (264192-124735487, default 124735487): 
Created a new partition 2 of type 'Linux' and of size 59.4 GiB.

Command (m for help): Partition number (1,2, default 2): Hex code or alias (type L to list all): 
Changed type of partition 'Linux' to 'W95 FAT32 (LBA)'.

Command (m for help): Partition number (1,2, default 2): 
The bootable flag on partition 1 is enabled now.

Command (m for help): The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

mkfs.fat 4.2 (2021-01-31)
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 15558912 4k blocks and 3891200 inodes
Filesystem UUID: 6eb5c597-4925-4cbd-8951-eb66dae2c4fa
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424

Allocating group tables: done                  
Writing inode tables: done                  
Creating journal (65536 blocks): done
Writing superblocks and filesystem accounting information: done   

 make partition done
------------end

```

## Step2 Install the rootfs

Two method to install the rootfs, pls select one. 

### install prebuild rootfs

```
[SDK-0901-j721s2-DRA829]:~/Startjacinto> make ra-sd-install-prebuild-rootfs
# /media/fredy/BOOT path OK !!!
# /media/fredy/rootfs path OK !!!
[ Tue Dec 12 10:27:08 AM CST 2023 ] INFO  >>>   --- 1. install the rootfs to SD card! 
- /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt already installed ! 
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/boot-adas-j721s2-evm.tar.gz to /media/fredy/BOOT ...
/home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/boot-adas-j721s2-evm.tar.gz to /media/fredy/BOOT ... Done
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/tisdk-adas-image-j721s2-evm.tar.xz to /media/fredy/rootfs ...
[sudo] password for fredy: 
/home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt
rm: cannot remove '/media/fredy/rootfs/home/root/.profile': No such file or directory
rm: cannot remove '/media/fredy/rootfs/lib/systemd/system-preset/*-edgeai-init.preset': No such file or directory
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/tisdk-adas-image-j721s2-evm.tar.xz to /media/fredy//media/fredy/rootfs ... Done
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/BOOT to /media/fredy/BOOT ...
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/BOOT to /media/fredy/BOOT ... Done
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/rootfs to /media/fredy/rootfs ...
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06-prebuilt/rootfs to /media/fredy/rootfs ... Done
Installing /home/fredy/Startjacinto/downloads/psdk_rtos_ti_data_set_09_01_00.tar.gz to /media/fredy/rootfs/opt/vision_apps/test_data ...
Installing /home/fredy/Startjacinto/downloads/psdk_rtos_ti_data_set_09_01_00.tar.gz to /media/fredy/rootfs/opt/vision_apps/test_data/ ... Done
sync
[ Tue Dec 12 10:30:58 AM CST 2023 ] INFO  >>>   --- 1. rootfs data set install done!!! 
```

### install the rootfs

```
[SDK-0901-j721s2-DRA829]:~/Startjacinto> make ra-sd-install-rootfs 
# /media/fredy/BOOT path OK !!!
# /media/fredy/rootfs path OK !!!
[ Tue Dec 12 10:41:19 AM CST 2023 ] INFO  >>>   --- 0. install the rootfs to sd card! 
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/boot-adas-j721s2-evm.tar.gz to /media/fredy/BOOT ...
/home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/boot-adas-j721s2-evm.tar.gz to /media/fredy/BOOT ... Done
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/tisdk-adas-image-j721s2-evm.tar.xz to /media/fredy/rootfs ...
/home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06
Installing /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06/tisdk-adas-image-j721s2-evm.tar.xz to /media/fredy//media/fredy/rootfs ... Done
sync
install done!!!
```

install the dataset

```
[SDK-0901-j721s2-DRA829]:~/Startjacinto> make ra-sd-install-auto-ti-data 
# /media/fredy/rootfs path OK !!!
# /media/fredy/BOOT path OK !!!
[ Tue Dec 12 10:46:32 AM CST 2023 ] INFO  >>>   --- 0. Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/fredy/rootfs/ 
cd /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06 && /home/fredy/Startjacinto/scripts/j7/install_psdkra_ti_data.sh  -i yes -s  09_01_00_06
[ Tue Dec 12 10:46:32 AM CST 2023 /home/fredy/Startjacinto/scripts/j7/install_psdkra_ti_data.sh] start---
[ Tue Dec 12 10:46:32 AM CST 2023 ] --- running dictionary: /home/fredy/Startjacinto/sdks/ti-processor-sdk-rtos-j721s2-evm-09_01_00_06//home/fredy/Startjacinto/scripts/j7
[ Tue Dec 12 10:46:32 AM CST 2023 ] >>> check_args: args --- 4
- get_arg_value: ArgsList: SETUP_YES_NO 4 -i -i yes -s 09_01_00_06
- get_arg_value: check : 4 -i -i
- get_arg_value: get -i- yes
- get_arg_value: check : 5 -i yes
- get_arg_value: check : 6 -i -s
--- -i SETUP_YES_NO: yes
- get_arg_value: ArgsList: VERSION 4 -s -i yes -s 09_01_00_06
- get_arg_value: check : 4 -s -i
- get_arg_value: check : 5 -s yes
- get_arg_value: check : 6 -s -s
- get_arg_value: get -s- 09_01_00_06
--- -s VERSION: 09_01_00_06
[ Tue Dec 12 10:46:32 AM CST 2023 ] --- parse_args: args --- 0
[ Tue Dec 12 10:46:32 AM CST 2023 ] --- launch: args --- 1
[ Tue Dec 12 10:46:32 AM CST 2023 ] --- launch: args --- yes
[ Tue Dec 12 10:46:32 AM CST 2023 ] --- setup_release_app: args --- 0
[ Tue Dec 12 10:46:32 AM CST 2023 ] - 1. download the package
 --- Pkg_name :  psdk_rtos_ti_data_set_09_01_00.tar.gz
 --- Pkg_name1:  psdk_rtos_ti_data_set_09_01_00_j721e.tar.gz
- /home/fredy/Startjacinto/downloads//psdk_rtos_ti_data_set_09_01_00.tar.gz already exist!
[ Tue Dec 12 10:46:32 AM CST 2023 ] - 2. update the dataset to SD
- update the /home/fredy/Startjacinto/downloads//psdk_rtos_ti_data_set_09_01_00.tar.gz to /media/fredy/rootfs/
- update the /home/fredy/Startjacinto/downloads//psdk_rtos_ti_data_set_09_01_00.tar.gz to /media/fredy/rootfs/ done
[ Tue Dec 12 10:47:55 AM CST 2023 /home/fredy/Startjacinto/scripts/j7/install_psdkra_ti_data.sh] done   !!!
[ Tue Dec 12 10:47:55 AM CST 2023 ] INFO  >>>   --- 0. Untar the file psdk_rtos_auto_ti_data_set_xx_xx_xx_xx.tar.gz to the SD card at below folder /media/fredy/rootfs/ --- Done 
```
